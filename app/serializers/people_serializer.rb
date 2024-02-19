class PeopleSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  attribute :detail do |person|
    person.detail
  end
end
