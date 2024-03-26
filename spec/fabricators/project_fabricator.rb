Fabricator(:project) do
  name { Faker::Name.first_name }
end
