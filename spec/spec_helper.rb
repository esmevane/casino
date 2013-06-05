require 'simplecov'

SimpleCov.start do
  add_filter "/spec/"
end

require 'casino'
require 'minitest/autorun'
require 'minitest/pride'
require 'database_cleaner'
require 'fabrication'

Mongoid.load! "./spec/support/mongoid.yml", :test


require './spec/fixtures/models/model'
require './spec/fixtures/models/note'
require './spec/fixtures/collections/collection'
require './spec/fixtures/collections/emails_by_day'

DatabaseCleaner[:mongoid].strategy = :truncation

class MiniTest::Spec
  before(:each) { DatabaseCleaner.start }
  after(:each) { DatabaseCleaner.clean }
end
