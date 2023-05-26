require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  it '性別をセレクト形式で登録できること' do
    visit signup_path

    fill_in '名前', with: 'テストユーザー'
    fill_in 'メールアドレス', with: 'test@example.com'
    select 'Male', from: '性別'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード確認', with: 'password'

    click_on '登録'

    expect(page).to have_text('ユーザー登録が完了しました')
    expect(page).to have_text('テストユーザー')
    expect(page).to have_text('Male')
  end
end
