module Casino
  class Lobby
    attr_accessor :collection

    def initialize(klass)
      self.collection = klass
    end

    def registry
      @registry ||= Hash.new
    end

    def add_registry(object)
      key = object.class.name.downcase.split("::").last.to_sym
      registry[key] ||= Array.new
      registry[key] << object
      registry[key] = registry[key].uniq
    end

  end
end