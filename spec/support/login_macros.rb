
module LoginMacros
  def login_as_user(user)
    visit root_path
    click_link 'ログイン'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'ログイン'
  end

  def login_as_non_female_user(non_female_user)
    visit root_path
    click_link 'ログイン'
    fill_in 'Email', with: 'b@example.com'
    fill_in 'Password', with: 'password'
    click_button 'ログイン'
  end

  
end