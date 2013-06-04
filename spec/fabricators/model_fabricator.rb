random_number = -> { rand(3) + 1 }

Fabricator(:model) do
  created_at { Date.today }
  source { %w(Google Facebook Twitter).shuffle.first }
end

Fabricator(:model_with_notes, from: :model) do
  after_create do |model|
    random_number.call.times { model.notes << Fabricate(:note, model: model) }
  end
end