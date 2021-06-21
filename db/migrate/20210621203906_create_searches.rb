class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.string :term
      t.integer :response_status
      t.json :response_body

      t.timestamps
    end
    add_index :searches, :term
  end
end
