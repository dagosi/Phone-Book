class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :number,          null: false, default: ""
      t.string :type,            null: false, default: ""
      t.references :contact

      t.timestamps
    end
  end
end
