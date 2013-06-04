module Casino
  class Question
    attr_accessor :name, :answer
    def initialize(name, answer)
      self.name = name
      self.answer = answer
    end
  end
end
