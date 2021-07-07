require 'rails_helper'

feature 'User can see his rewards', %q{
  In order entertain self-esteem
  As an authenticate user 
  User can view their rewards
} do
  
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  
  given(:question) { create(:question, author: user) }
  given!(:reward) { create(:reward, question: question, user: user) }
  
  scenario 'Authenticated user can view their rewards', js: true  do
    sign_in(user)
    click_on 'View my rewards'

    expect(page).to have_content question.title
    expect(page).to have_content reward.name
  end

  scenario "Unauthenticated user can't view their rewards"  do
    visit questions_path
    expect(page).to have_no_link 'View my rewards'
  end
end