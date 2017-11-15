#!/usr/bin/ruby

require "mysql2"

require_relative "SampleWeights"
require_relative "GeneralDAO"

class SampleWeightsDAO < GeneralDAO
  #consider using stored procedure
  def initialize(my, selectSQL = %Q{SELECT id, chloroform_weight, bromoform_weight, bromodichloromethane_weight, dibromichloromethane_weight FROM watersupply.factor_weights })
    super(my, selectSQL)
  end

  private 

  def fetchResults(rs)
    rows = []
    rs.each do |row|
      chloroform_weight = row['chloroform_weight'].nil? ? 0 : row['chloroform_weight']
      bromoform_weight = row['bromoform_weight'].nil? ? 0 : row['bromoform_weight']
      bromodichloromethane_weight = row['bromodichloromethane_weight'].nil? ? 0 : row['bromodichloromethane_weight']
      dibromichloromethane_weight = row['dibromichloromethane_weight'].nil? ? 0 : row['dibromichloromethane_weight']

      dto = SampleWeights.new(row['id'], chloroform_weight, bromoform_weight, bromodichloromethane_weight, dibromichloromethane_weight)
      rows << dto
    end
    return rows
  end

end
