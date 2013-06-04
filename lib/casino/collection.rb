module Casino
  module Collection
    attr_reader :intersection, :answer

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def dimension(label, field, queries, approach = Hash.new)
        register Dimension.new(label, field, queries, approach)
      end

      def question(name, answer)
        register Question.new(name, answer)
      end

      def focus(model)
        register Focus.new(model)
      end

      def lobby
        @lobby ||= Lobby.new(self)
      end

      def register(object)
        lobby.add_registry(object)
        object
      end

    end

    def dimensions
      registry[:dimension]
    end

    def questions
      registry[:question]
    end

    def focus
      registry[:focus]
    end

    def key
      join       = "_and_"
      what       = questions.map(&:name).join(join)
      parameters = dimensions.map(&:field).join(join)
      my_name    = self.class.name.underscore
      targets    = focus.map(&:model).map(&:name).map(&:underscore).sort.
        join(join)
      "#{my_name}_asks_#{targets}_about_#{what}_by_#{parameters}"
    end

    def queries(dimension)
      send(dimension.queries).map { |query| query.merge(dimension) }
    end

    def query(label, *criteria)
      Query.new(label, [], *criteria)
    end

    def intersections
      focus.reduce(Array.new) do |aggregator, answer_focus|
        aggregator + intersections_for(answer_focus)
      end
    end

    def results
      persist_results if pending_results.any?
      stored_results
    end

    def update
      merge all_results
      stored_results
    end

    def merge(documents)
      store.merge *documents
    end

    def persist_results
      merge collected_results
    end

    def collected_results
      stored_results + pending_results
    end

    def pending_results
      determine_results pending_intersections
    end

    def all_results
      determine_results intersections
    end

    def determine_results(given_intersections)
      given_intersections.map do |current_intersection|
        @intersection = current_intersection.criteria
        result = { _id: intersection.selector }.merge(answers)
      end
    end

    def answers
      questions.reduce(Hash.new) do |hash, question|
        hash.merge question.name => send(question.answer)
      end
    end

    def stored_results
      store.in(id: intersection_ids)
    end
    alias :stored_intersections :stored_results

    def intersection_ids
      intersections.map(&:selector)
    end

    def intersection
      @intersection || focus_model.scoped
    end

    def store
      @store ||= Store.new key
    end

    def projection
      Casino::Projection.new(focus_model).where(intersection.selector)
    end

    def answer(method_name)
      send(method_name)
    end

    def pending_intersections
      ids = stored_results.map(&:id)
      intersections.reject do |intersection|
        ids.include? intersection.selector
      end
    end
    private :pending_intersections

    def focus_model
      focus.map(&:model).first
    end
    private :focus_model

    def all_queries
      dimensions.map { |dimension| queries(dimension) }
    end
    private :all_queries

    def intersections_for(answer_focus)
      product_of_all_queries.map do |conditions|
        label = conditions.map(&:label)
        Intersection.new label, answer_focus.build_criteria(*conditions)
      end
    end
    private :intersections_for

    def get_product(head, *tail)
      head.product *tail
    end
    private :get_product

    def product_of_all_queries
      get_product(*all_queries)
    end
    private :product_of_all_queries

    def registry
      self.class.lobby.registry
    end
    private :registry

  end
end
