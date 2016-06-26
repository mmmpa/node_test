class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name
      t.references :owner, index: true, foreign_key: true
      t.references :node, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
