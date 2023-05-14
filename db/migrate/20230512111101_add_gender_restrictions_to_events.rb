class AddGenderRestrictionsToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :male_only, :boolean
    add_column :events, :female_only, :boolean
  end
end
