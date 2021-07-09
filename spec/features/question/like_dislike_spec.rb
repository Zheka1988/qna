require 'rails_helper'

feature 'Not author can voiting for the question', %q{
  In order ranking authorized user can
  voiting for question if he is not author the question
} do
  given!(:user) { create :user }
  given!(:other_user) { create(:user) }
  given!(:question) { create :question, author: user }

  scenario 'Unauthenticated user can not voiting the question' do
    visit questions_path

    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end  

  describe 'Authenticated user' do
    scenario 'author question, can not voiting the question' do
      sign_in(user)
      visit questions_path

      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
    end

    scenario 'not author question, voiting like the question', js: true do
      sign_in(other_user)
      visit questions_path

      within '.questions' do
        click_on 'Like'
      end
      expect(page).to have_content '1'
    end

    scenario 'not author question, voiting dislike the question', js: true do
      sign_in(other_user)
      visit questions_path

      within '.questions' do
        click_on 'Dislike'
      end
      expect(page).to have_content '-1'
    end
  end
end
