require 'rails_helper'
RSpec.describe Person, type: :model do
  context 'person' do
    let(:person) { FactoryBot.create(:person) }

    it 'should be valid person with all attributes' do
      expect(person.valid?).to eq(true)
    end

    it 'should not be valid person without name attribute' do
      person = build(:person, name: nil)
      person.valid?
      expect(person.errors[:name]).to include("can't be blank")
    end
  end
end