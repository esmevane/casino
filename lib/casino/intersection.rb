libs = %w(equivalence base all include greater lesser recurse expression)
path = File.dirname(__FILE__)

libs.each do |lib|
  require "#{path}/intersection/match/#{lib}"
end

module Casino
  class Intersection
    attr_accessor :label, :criteria

    delegate :selector, to: :criteria

    def initialize(label, criteria)
      self.label = label
      self.criteria = criteria
    end

    def match?(document)
      selector.keys.map { |key| match_key_against(document, key) }.all?
    end

    private

    def match_key_against(document, key)
      Match::Base.new(document, key, selector).evaluate
    end

  end
end