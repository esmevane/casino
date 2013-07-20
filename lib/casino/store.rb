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
        document = document.mongoize
        criteria = find _id: document['_id']
        criteria.upsert document
      end
    end

    def criteria
      @criteria ||= collection_class.scoped
    end

    private

    def session
      @session ||= Mongoid.default_session
    end

  end
end
