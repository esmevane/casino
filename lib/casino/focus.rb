module Casino
  class Focus
    attr_accessor :model

    def initialize(model)
      self.model = model
    end

    def hash
      model.hash
    end

    def ==(other)
      other.is_a?(self.class) && other.model == model
    end
    alias :eql? :==

    def build_criteria(*queries)
      conditions = queries.map(&:conditions).flatten(1)
      conditions.reduce(model) do |criteria, condition_pair|
        criteria.send(condition_pair.first, condition_pair.last)
      end
    end

  end
end
