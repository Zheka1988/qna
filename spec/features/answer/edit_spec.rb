require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author af answer
  I'd like to be able edit my answer
} do
  given(:user) { create :user }
  given(:other_user) { create :user }
  given!(:question) { create :question, author: user}
  given!(:answer) { create :answer, question: question, author: user }

  scenario 'Unauthenticated can not edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)
      
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits not his answer', js: true do
      sign_in other_user
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end

end