module Casino
  class Intersection
    module Match
      class Base
        attr_accessor :document, :field, :key, :selector, :value

        def initialize(document, key, selector, value = nil)
          self.document = document
          self.field    = selector[key]
          self.key      = key
          self.selector = selector
          self.value    = document_value || value
        end

        def evaluate
          matcher.evaluate
        end

        def match_arguments
          [ key, value, document, field ]
        end

        def matchers
          matcher_classes.map { |class_name| matcher_for class_name }
        end

        def matcher
          matchers.find { |matcher| matcher.eligible? }
        end

        def matcher_for(class_name)
          class_name = String(class_name).humanize
          Match.const_get(class_name).new(*match_arguments)
        end

        private

        def matcher_classes
          %w(all include recurse greater lesser expression equivalence)
        end

        def document_value
          document.send(key) if document.respond_to?(key)
        end

      end
    end
  end
end