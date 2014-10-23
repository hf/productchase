class AddPersonalTitleToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :personal_title, :string, default: nil
  end
end
