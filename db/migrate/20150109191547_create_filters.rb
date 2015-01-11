class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
    	t.integer :user_id
    	t.string :name 
    	t.text :description
    	t.text :slips
      t.timestamps
    end
  end
end
