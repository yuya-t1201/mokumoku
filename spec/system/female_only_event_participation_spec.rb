require 'rails_helper'

RSpec.describe '女性限定イベント参加', type: :system do
  let(:female_user) { FactoryBot.create(:user) }
  let(:male_user) { FactoryBot.create(:user, gender: :male) }

  before do
    @event = FactoryBot.create(:event, female_only: true)
  end

  it '女性ユーザーは女性限定イベントに参加できる' do
    login_as_user(female_user)
    visit event_path(@event)
    click_on 'このもくもく会に参加する'
    expect(page).to have_text('参加の申込をしました')
  end

  it '女性以外の場合、女性限定イベントの詳細ページを開いた際に「このもくもく会に参加する」が表示されない' do
    login_as_user(male_user)
    visit event_path(@event)
    expect(page).not_to have_text('このイベントは女性のみ参加可能です')
  end
end
