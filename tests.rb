#!/usr/bin/ruby
 
require "mysql2"
require_relative "SampleWeights"
require_relative "SampleWeightsDAO"

require "./WaterSample"
require "./WaterSampleDAO"
        
begin
  client = Mysql2::Client.new(:host => "localhost", :username => "carjam", :password => "XYZ")

  #weights object
  dao = SampleWeightsDAO.new(client)
  w = dao.findWhereIdEquals(1)
  puts w.id
  puts w.chloroform_weight 
  puts w.bromoform_weight
  puts w.bromodichloromethane_weight
  puts w.dibromichloromethane_weight

  #water samples object
  sample = WaterSample.find(2)#dao2.findWhereIdEquals(2)#1)
  puts sample.id
  puts sample.site
  puts sample.chloroform
  puts sample.bromoform
  puts sample.bromodichloromethane
  puts sample.dibromichloromethane
  puts sample.factor(6)
  puts sample.factor(1)

  sample.to_hash.each do |key, value|
    puts "#{key}:#{value}"
  end

rescue Mysql2::Error => e
    puts e.errno
    puts e.error

ensure
    client.close if client
end
