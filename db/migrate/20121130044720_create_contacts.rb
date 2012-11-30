class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false, default: ""
      t.string :last_name,  null: false, default: ""
     
      t.timestamps
    end
  end
end
