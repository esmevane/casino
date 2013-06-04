require 'csv'
require 'mongoid'

libs = %w(collection dimension focus intersection lobby projection
  query question store version)
path = File.dirname(__FILE__)

libs.each do |lib|
  require "#{path}/casino/#{lib}"
end

module Casino
end
