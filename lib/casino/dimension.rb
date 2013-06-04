module Casino
  class Dimension
    attr_accessor :label, :field, :queries, :approach
    def initialize(label, field, queries, approach = Hash.new)
      self.label    = label
      self.field    = field
      self.queries  = queries
      self.approach = { operator: :where }.merge(approach)
    end
  end
end
