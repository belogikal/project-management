require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'associations' do
    it 'belongs to a team' do
      association = described_class.reflect_on_association(:team)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many project_members' do
      association = described_class.reflect_on_association(:project_members)
      expect(association.macro).to eq :has_many
      expect(association.options).to include(dependent: :destroy)
    end

    it 'has many projects through project_members' do
      association = described_class.reflect_on_association(:projects)
      expect(association.macro).to eq :has_many
      expect(association.options).to include(:through)
      expect(association.options[:through]).to eq :project_members
    end
  end

  describe 'validations' do
    let!(:member) { Fabricate(:member) }

    it 'is valid with default fabricator' do
      expect(member).to be_valid
    end

    it 'is invalid if first name is not present' do
      member.first_name = nil
      expect(member).not_to be_valid
      expect(member.errors.full_messages).to eq(["First name can't be blank"])
    end

    it 'is invalid if last name is not present' do
      member.last_name = nil
      expect(member).not_to be_valid
      expect(member.errors.full_messages).to eq(["Last name can't be blank"])
    end
  end
end
