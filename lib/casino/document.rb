module Casino
  class Document

    def initialize(key, question_names)
      @key = key
      @question_names = Array question_names
    end

    def compose
      klass = Class.new
      klass.send :include, Mongoid::Document
      klass.store_in collection: @key
      assign_fields klass
      klass
    end

    private

    def assign_fields klass
      @question_names.each do |name|
        name = String(name).parameterize.underscore.to_sym
        klass.field name
      end
    end

  end
end