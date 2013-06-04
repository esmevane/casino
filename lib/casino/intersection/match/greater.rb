module Casino
  class Intersection
    module Match
      class Greater < Equivalence

        def eligible?
          %w($gt $gte).include? key
        end

        def evaluate
          greater_than? ? greater_than! : greater_than_or_equal!
        end

        private

        def greater_than?
          key == '$gt'
        end

        def greater_than!
          evolved_value > evolved_field
        end

        def greater_than_or_equal!
          evolved_value >= evolved_field
        end

        def evolved_value
          evolve value
        end

        def evolved_field
          evolve field
        end

        def evolve(instance)
          instance.class.evolve(instance)
        end

      end
    end
  end
end