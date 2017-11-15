#!/usr/bin/ruby

require "mysql2"
require_relative "SampleWeights"

class WaterSample
  def initialize(id, site, chloroform = 0, bromoform = 0, bromodichloromethane = 0, dibromichloromethane = 0)
    @id = id
    @site = site
    @chloroform = chloroform
    @bromoform = bromoform
    @bromodichloromethane = bromodichloromethane
    @dibromichloromethane = dibromichloromethane
    @factors = {}
  end

  attr_reader :id
  attr_reader :site
  attr_reader :chloroform
  attr_reader :bromoform
  attr_reader :bromodichloromethane
  attr_reader :dibromichloromethane

  def self.find(sample_id)
    begin
      connection = Mysql2::Client.new(:host => "localhost", :username => "carjam", :password => "XYZ") #consider external connection pooling for extensibility
      dao = WaterSampleDAO.new(connection)
      return dao.findWhereIdEquals(sample_id)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    ensure
      connection.close if connection
    end
  end


  # get the calc'd factor by the given id for weights
  def factor(weight_id)
    cachedVal = @factors[weight_id]
    
    if(cachedVal)
	return cachedVal
    else
      #go get the weights from the DB by id
      weights = SampleWeights.find(weight_id)
     
      #calculate and add to collection if not nil 
      calcVal = calculateFactor(weights)
      if(calcVal)
        @factors[weight_id] = calcVal
      end
      
      return calcVal
    end
  end


  def to_hash
    #get all weights from DB
    allWeights = SampleWeights.find(nil)

    #we should consider adding a versioning mechanism to make sure our data is not out of data - is this the schema_migration table?
    #add all new values to the collection
    allWeights.each do |row|
      cachedVal = @factors[row.id]

      unless(cachedVal)
        calcVal = calculateFactor(row)
        if(calcVal)
          @factors[row.id] = calcVal
        end
      end
    end

    #now convert to hash and return using reflection
    return Hash[*instance_variables.map { |v|
      [v.to_sym, instance_variable_get(v)]
    }.flatten]
  end


  private

  #formula is assumed - need to confirm requirements
  def calculateFactor(weights)
    if(weights)
      calcdFactor = (weights.chloroform_weight * @chloroform) + (weights.bromoform_weight * @bromoform) + (weights.bromodichloromethane_weight * @bromodichloromethane) + (weights.dibromichloromethane_weight * @dibromichloromethane)
      return calcdFactor
    else
      return nil #a nil return value for nil input gives us more information than returning a 0
    end
  end

end
