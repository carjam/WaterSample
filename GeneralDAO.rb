#!/usr/bin/ruby

require "mysql2"

class GeneralDAO
  def initialize(my, selectSQL)
    @my = my
    @selectSQL = selectSQL
  end
  
  def findAll()
    begin
      rs = @my.query(@selectSQL)
      result = fetchResults(rs)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end

    return result
  end

  def findWhereIdEquals(id)
    begin
      rs = @my.query("#{@selectSQL} WHERE id = #{id}")
      result = fetchResults(rs)
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
    end

    return result[0]
  end

end

