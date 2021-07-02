require 'rails_helper'

feature 'User can delete any attach file for questions', %q{
  Registered user can delete attach file his question
} do

  given(:user) { create(:user) }
  given!(:other_user) { create (:user) }
  given!(:question) { create :question, author: user }

  scenario 'delete attach any file/s if user author the question', js: true do
    sign_in user
    visit questions_path(question)

    within '.questions' do
      click_on 'Edit'
      attach_file 'Files', ["#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'
    end

    visit question_path(question)
    click_on 'Delete file'
    page.driver.browser.switch_to.alert.accept

    expect(page).to_not have_link 'spec_helper.rb"'
  end


  scenario 'delete attach any file/s if user not author the question', js: true do
    sign_in user
    visit questions_path(question)

    within '.questions' do
      click_on 'Edit'
      attach_file 'Files', ["#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'
    end

    click_on 'Logout'
    sign_in other_user
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end

end