class Note
  include Mongoid::Document

  field :views, type: Integer

  embedded_in :model
end