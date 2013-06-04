module Casino
  class Intersection
    module Match
      class All < Equivalence

        def eligible?
          key == '$and'
        end

        def evaluate
          matchers.map(&:evaluate).all?
        end

        private

        def matchers
          field.reduce(Array.new) do |list, element|
            list + build_bases_with_element_keys(element)
          end
        end

        def build_bases_with_element_keys(element)
          element.keys.map { |key| Base.new(document, key, element, value) }
        end

      end
    end
  end
end