module Casino
  class Intersection
    module Match
      class Expression < Equivalence
        def eligible?
          field.is_a? Regexp
        end

        def evaluate
          !(value =~ field).nil?
        end
      end
    end
  end
end