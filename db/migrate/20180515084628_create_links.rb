class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.text :long_url
      t.string :short_url
      t.integer :status_code, default: 301

      t.timestamps
    end

    add_index :links, :short_url
  end
end
