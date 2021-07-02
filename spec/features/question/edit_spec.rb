require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author af question
  I'd like to be able edit my question
} do
  given(:user) { create :user }
  given(:other_user) { create :user }
  given!(:question) { create :question, author: user}

  scenario 'Unauthenticated can not edit question', js: true do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in user
      visit questions_path
      
      within '.questions' do
        click_on 'Edit'
        fill_in 'Body question', with: 'Edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits not his question', js: true do
      sign_in other_user
      visit questions_path
      expect(page).to_not have_link 'Edit'
    end

    scenario 'edits his question with errors', js: true do
      sign_in user
      visit questions_path
      
      within '.questions' do
        click_on 'Edit'
        fill_in 'Body question', with: ""

        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

end