class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.references :user, foreign_key: true
      t.string :google_id
      t.string :title
      t.string :author
      t.text :description
      t.string :image_links
      t.integer :my_rating
      t.text :notes

      t.timestamps
    end
  end
end
