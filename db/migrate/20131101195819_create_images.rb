class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :user
      t.string :caption
      t.text :description

      t.timestamps
    end
    add_index :images, :user_id
  end
end
