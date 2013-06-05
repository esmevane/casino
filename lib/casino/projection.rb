module Casino
  class Projection
    attr_accessor :target, :pipeline

    def initialize(klass, pipeline = [])
      self.target = klass
      self.pipeline = pipeline
    end

    def results
      target.collection.aggregate(pipeline)
    end

    def mongoize(hash)
      hash.keys.map { |key| build_mongoized_hash(hash, key) }.reduce(&:merge)
    end

    def group(conditions)
      clone_with group: conditions
    end
    alias :pivot :group

    def project(conditions)
      clone_with project: conditions
    end
    alias :describe :project
    alias :build :project

    def unwind(conditions)
      clone_with unwind: conditions
    end
    alias :expand :unwind

    def match(conditions)
      clone_with match: conditions
    end
    alias :where :match
    alias :find :match

    def sort(conditions)
      clone_with sort: conditions
    end
    alias :order :sort

    def skip(conditions)
      clone_with skip: conditions
    end
    alias :offset :skip

    def limit(conditions)
      clone_with limit: conditions
    end

    private

    def clone_with(condition)
      self.class.new target, pipeline + [mongoize(condition)]
    end

    def build_mongoized_hash(hash, key)
      new_key = mongo_ready(key)
      value = hash[key]
      value = value.is_a?(Hash) ? mongoize(value) : mongo_ready(value)
      { new_key => evolve(value) }
    end

    def evolve(value)
      value.class.respond_to?(:evolve) ? value.class.evolve(value) : value
    end

    def mongo_ready(object)
      object.is_a?(Symbol) ? "$#{object}" : object
    end

  end
end