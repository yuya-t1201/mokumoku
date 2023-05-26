class AddDefaultToGenderInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :gender, 0
  end
end
