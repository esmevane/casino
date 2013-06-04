module Casino
  class Intersection
    module Match
      class Equivalence
        attr_accessor :document, :field, :key, :value

        def initialize(key, value, document, field)
          self.key = key
          self.document = document
          self.field = field
          self.value = value
        end

        def eligible?
          true
        end

        def evaluate
          value == field
        end

      end
    end
  end
end