#!/usr/bin/ruby

require "mysql2"
require_relative "WaterSample"
require_relative "GeneralDAO"

class WaterSampleDAO < GeneralDAO
  #consider using stored procedure
  def initialize(my, selectSQL = %Q{SELECT id, site, chloroform, bromoform, bromodichloromethane, dibromichloromethane FROM watersupply.water_samples })
  	super(my, selectSQL)
  end

  private 

  def fetchResults(rs)
    rows = []
    rs.each do |row|
      chloroform = row['chloroform'].nil? ? 0 : row['chloroform']
      bromoform = row['bromoform'].nil? ? 0 : row['bromoform']
      bromodichloromethane = row['bromodichloromethane'].nil? ? 0 : row['bromodichloromethane']
      dibromichloromethane = row['dibromichloromethane'].nil? ? 0 : row['dibromichloromethane']

      dto = WaterSample.new(row['id'], row['site'], chloroform, bromoform, bromodichloromethane, dibromichloromethane)
      rows << dto
    end
    return rows
  end

end
