module Casino
  class Query
    attr_accessor :label, :criteria, :conditions

    def initialize(label, conditions, *criteria)
      self.label = label
      self.conditions = conditions
      self.criteria = criteria
    end

    def merge(dimension)
      self.class.new(label, build_conditions(dimension), *criteria)
    end

    def build_conditions(dimension)
      criteria.map do |condition|
        [ dimension.approach[:operator],
          { dimension.field => condition } ]
      end
    end

  end
end
