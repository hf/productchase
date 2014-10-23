class AddDayOfEntryToProducts < ActiveRecord::Migration
  def up
    add_column :products, :day_of_entry, :datetime

    Product.all.each do |product|
      product.day_of_entry = product.created_at.midnight
      product.save!
    end

    change_column :products, :day_of_entry, :datetime, null: false, default: nil

    add_index  :products, :day_of_entry
  end

  def down
    remove_index  :products, :day_of_entry
    remove_column :products, :day_of_entry
  end
end
