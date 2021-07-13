require 'rails_helper'

feature 'Not author can voiting for the answer', %q{
  In order ranking authorized user can
  voiting for answer if not author the answer
} do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user can not voiting the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end

  describe 'Authenticated user' do
    scenario 'author answer, can not voiting the answer' do
      sign_in user
      visit question_path(question)

      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
    end

    scenario 'not author answer, voiting like the answer', js: true do
      sign_in(other_user)
      visit question_path(question)

      within '.answers' do
        click_on 'Like'
      end
      expect(page).to have_content '1'
    end

    scenario 'not author answer, voiting dislike the answer', js: true do
      sign_in(other_user)
      visit question_path(question)

      within '.answers' do
        click_on 'Dislike'
      end
      expect(page).to have_content '-1'
    end

  end
end