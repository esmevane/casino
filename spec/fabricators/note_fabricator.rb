Fabricator(:note) do
  views { rand(3) + 1 }
end