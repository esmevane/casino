module Casino
  class Intersection
    module Match
      class Lesser < Greater

        def eligible?
          %w($lt $lte).include? key
        end

        def evaluate
          lesser_than? ? lesser_than! : lesser_than_or_equal!
        end

        private

        def lesser_than?
          key == '$lt'
        end

        def lesser_than!
          evolved_value < evolved_field
        end

        def lesser_than_or_equal!
          evolved_value <= evolved_field
        end

      end
    end
  end
end