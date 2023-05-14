class AddDisplayGenderToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :display_gender, :boolean
  end
end
