require 'rails_helper'

feature 'User can registered in the system', %q{
  In order to work with the system
  As an authenticated user
  I'd like be able registration 
} do
  
  given(:user) { create(:user) }

  scenario 'Unregistered user tries register in the system' do
    visit new_user_registration_path

    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario "Registered user tries register in the system"  do
    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end