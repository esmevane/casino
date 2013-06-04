module Casino
  module Collection
    attr_accessor :intersection, :answer

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
      if pending_results.any?
        persist_results
        stored_results
      else
        stored_results
      end
    end

    def persist_results
      store.merge *collected_results
    end

    def collected_results
      stored_results + pending_results
    end

    def pending_results
      pending_intersections.map do |current_intersection|
        self.intersection = current_intersection.criteria
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

    # Untested

    def pending_intersections
      ids = stored_results.map(&:id)
      intersections.reject do |intersection|
        ids.include? intersection.selector
      end
    end

    def to_csv
      headers = dimensions.map(&:label) + questions.map(&:name)
      CSV.generate(headers: headers, write_headers: true) do |csv|
        intersections.each do |current_intersection|
          self.intersection = current_intersection.criteria
          whereabouts = current_intersection.label
          answers = questions.map { |question| send(question.answer) }
          csv << whereabouts + answers
        end
      end
    end

    # -- End of untested code

    def store
      @store ||= Store.new key
    end

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
