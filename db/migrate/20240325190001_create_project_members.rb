class CreateProjectMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :project_members do |t|
      t.belongs_to :member, null: false
      t.belongs_to :project, null: false

      t.timestamps
    end
  end
end
