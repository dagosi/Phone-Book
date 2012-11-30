class CreatePepes < ActiveRecord::Migration
  def change
    create_table :pepes do |t|

      t.timestamps
    end
  end
end
