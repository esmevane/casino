module Casino
  class Store
    attr_accessor :collection_class, :collection_name

    delegate :drop, :find, :indexes, :insert, to: :collection

    delegate :count, :distinct, :each, :first, :limit, :remove, :remove_all,
      :select, :skip, :sort, :update, :update_all, :upsert, to: :query

    delegate :where, :in, to: :criteria

    def initialize(document_class)
      self.collection_class = document_class
      self.collection_name = document_class.collection_name
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
      @criteria ||= collection_class.scoped
    end

    def mongoize(hash)
      hash.keys.map { |key| build_mongoized_hash(hash, key) }.reduce(&:merge)
    end

    private

    def session
      @session ||= Mongoid.default_session
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
