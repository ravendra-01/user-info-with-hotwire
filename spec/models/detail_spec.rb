require 'rails_helper'
RSpec.describe Person, type: :model do
  context 'person' do
    let(:detail) { FactoryBot.create(:detail) }

    it 'should be valid detail with all attributes' do
      expect(detail.valid?).to eq(true)
    end

    it 'should not be valid detail without email attribute' do
      detail = build(:detail, email: nil)
      detail.valid?
      expect(detail.errors[:email]).to include("can't be blank")
    end
  end
end