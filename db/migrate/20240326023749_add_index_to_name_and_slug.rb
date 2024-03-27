class AddIndexToNameAndSlug < ActiveRecord::Migration[7.1]
  def change
    add_index :teams, :name, unique: true
    add_index :teams, :slug, unique: true
    add_index :projects, :name, unique: true
    add_index :projects, :slug, unique: true
  end
end
