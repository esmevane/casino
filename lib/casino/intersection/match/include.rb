module Casino
  class Intersection
    module Match
      class Include < Equivalence
        def eligible?
          key == "$in"
        end

        def evaluate
          field.include?(value)
        end
      end
    end
  end
end