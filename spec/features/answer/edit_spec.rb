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
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits not his answer', js: true do
      sign_in other_user
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end

end