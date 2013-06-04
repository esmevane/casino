module Casino
  class Intersection
    module Match
      class Recurse < Equivalence

        def eligible?
          field.is_a? Hash
        end

        def evaluate
          keys = field.keys
          bases = keys.map { |key| Base.new(document, key, field, value) }
          bases.map(&:evaluate).all?
        end

      end
    end
  end
end