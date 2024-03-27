require 'rails_helper'

RSpec.describe ProjectMember, type: :model do
  describe 'validations' do
    let!(:project_member) { Fabricate(:project_member) }

    it 'validates uniqueness of project_id scoped to member_id' do
      project_member.project_id = 1
      project_member.member_id = 1
      project_member.save
      existing_record = described_class.create(project_id: 1, member_id: 1)

      expect(existing_record).to be_invalid
      expect(existing_record.errors[:project_id]).to include('has already been taken')
    end

    it 'is valid with valid default fabricator' do
      expect(project_member).to be_valid
    end

    it 'is invalid if member is not present' do
      project_member.member = nil
      expect(project_member).not_to be_valid
      expect(project_member.errors.full_messages).to eq(['Member must exist'])
    end

    it 'is invalid if project is not present' do
      project_member.project = nil
      expect(project_member).not_to be_valid
      expect(project_member.errors.full_messages).to eq(['Project must exist'])
    end
  end
end
