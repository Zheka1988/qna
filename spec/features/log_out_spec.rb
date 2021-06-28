require 'rails_helper'

feature 'User can log out', %q{
  In order to stop working with the system
  As an authenticated user
  I'd like be able log out 
} do
  
  given(:user) { create :user }
  
  scenario 'Authenticated user can logout system'  do
    sign_in(user)
    visit questions_path
    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario "Unauthenticated user can't logout system"  do
    visit questions_path

    expect(page).to_not have_link 'Logout'
  end
end