FactoryBot.define do
  factory :detail, class: 'Detail' do
    age { rand(0...100) }
    title { Faker::Name.prefix }
    phone { Faker::PhoneNumber.phone_number_with_country_code }
    email { Faker::Internet.email }
    association :person, factory: :person
  end
end
