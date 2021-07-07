require 'rails_helper'

feature 'User can delete any link for questions', %q{
  Registered user can delete link his question
} do

  given(:user) { create(:user) }
  given!(:other_user) { create (:user) }
  given!(:question) { create :question, author: user }
  given(:google) { "https://google.com" }

  background do 
    sign_in user
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: google
    click_on 'Ask'
  end

  scenario 'delete link if user author the question', js: true do
    click_on 'Delete Link'

    page.driver.browser.switch_to.alert.accept

    expect(page).to_not have_link 'My link', href: google
  end


  scenario 'delete link if user not author the question', js: true do
    click_on 'Logout'
    sign_in other_user
    visit question_path(question)

    expect(page).to_not have_link 'Delete Link'
  end

end