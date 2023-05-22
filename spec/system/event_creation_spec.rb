require 'rails_helper'

RSpec.describe "イベント作成", type: :system do
    let(:user) { FactoryBot.create(:user) }
    let(:non_female_user) { FactoryBot.create(:non_female_user) }
    
    it "女性ユーザーでイベント作成する際に、女性限定のチェックボックスが表示されている" do
      login_as_user(user)
      visit new_event_path

      expect(page).to have_field('event_female_only', visible: :visible, type: 'checkbox')
    end
    
    it "女性限定にチェックを入れイベントを作成した場合、女性限定イベントが作成される" do
      login_as_user(user)
      visit new_event_path
    
      fill_in 'Title', with: 'Female Only Event'
      fill_in 'Content', with: '女性限定です'
      fill_in 'event_held_at', with: '2023-05-21T12:30'
      select '東京都', from: 'event_prefecture_id'
      check "event_female_only"
      click_button '登録'
      expect(page).to have_text('イベントが作成されました')
      expect(page).to have_text('Female Only Event')
      expect(page).to have_text('Female Only')
    end
    
    it "女性ではないユーザーがイベント作成する際に、女性限定のチェックボックスが表示されない" do
      login_as_non_female_user(:non_female_user)
      visit new_event_path

      expect(page).not_to have_field('event_female_only', visible: :visible, type: 'checkbox')
    end
end