FactoryBot.define do
  factory :person, class: 'Person' do
    name { Faker::Name.name }
  end
end
