module Casino
  class Store
    attr_accessor :collection_name

    delegate :drop, :find, :indexes, :insert, to: :collection

    delegate :count, :distinct, :each, :first, :limit, :remove, :remove_all,
      :select, :skip, :sort, :update, :update_all, :upsert, to: :query

    delegate :where, :in, to: :criteria

    def initialize(collection_name)
      self.collection_name = collection_name
    end

    def collection
      @collection ||= session[collection_name.to_sym]
    end

    def query
      @query ||= collection.find
    end

    def merge(*documents)
      documents.each do |document|
        document = mongoize document
        criteria = find _id: document['_id']
        criteria.upsert document
      end
    end

    def criteria
      @criteria ||= build_criteria
    end

    def mongoize(hash)
      hash.keys.map { |key| build_mongoized_hash(hash, key) }.reduce(&:merge)
    end

    private

    def session
      @session ||= Mongoid.default_session
    end

    def build_criteria
      klass = Class.new
      klass.send(:include, Mongoid::Document)
      klass.store_in collection: collection_name
      klass.scoped
    end

    def evolve(value)
      value.class.respond_to?(:evolve) ? value.class.evolve(value) : value
    end

    def build_mongoized_hash(hash, key)
      value = hash[key]
      value = value.is_a?(Hash) ? mongoize(value) : value
      { key => evolve(value) }
    end

  end
end
