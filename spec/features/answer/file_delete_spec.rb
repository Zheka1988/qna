require 'rails_helper'

feature 'User can delete any attach file for answer', %q{
  Registered user can delete attach file his answer
} do

  given(:user) { create(:user) }
  given!(:other_user) { create (:user) }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer ,question: question, author: user }

  scenario 'delete attach any file/s if user author the answer', js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      click_on 'Edit'
      attach_file 'Files', ["#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'
    end

    click_on 'Delete file'
    page.driver.browser.switch_to.alert.accept

    expect(page).to_not have_link 'spec_helper.rb"'
  end


  scenario 'delete attach any file/s if user not author the answer', js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
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
