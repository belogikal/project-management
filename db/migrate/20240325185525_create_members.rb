class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
