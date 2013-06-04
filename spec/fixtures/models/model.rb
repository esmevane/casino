class Model
  include Mongoid::Document

  field :created_at
  field :source

  embeds_many :notes
end
