#!/usr/bin/ruby

require_relative "SampleWeightsDAO"

class SampleWeights
  def initialize(id, chloroform_weight = 0, bromoform_weight = 0, bromodichloromethane_weight = 0, dibromichloromethane_weight = 0)
    @id = id
    @chloroform_weight = chloroform_weight
    @bromoform_weight = bromoform_weight
    @bromodichloromethane_weight = bromodichloromethane_weight
    @dibromichloromethane_weight = dibromichloromethane_weight
  end

  attr_reader :id
  attr_reader :chloroform_weight
  attr_reader :bromoform_weight
  attr_reader :bromodichloromethane_weight
  attr_reader :dibromichloromethane_weight

  def self.find(weight_id)
    begin
      connection = Mysql2::Client.new(:host => "localhost", :username => "carjam", :password => "XYZ") #consider external connection pooling for extensibility
      dao = SampleWeightsDAO.new(connection)
      
      if(weight_id)
        return dao.findWhereIdEquals(weight_id)
      else
        return dao.findAll()
      end
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    ensure
      connection.close if connection
    end
  end
end
