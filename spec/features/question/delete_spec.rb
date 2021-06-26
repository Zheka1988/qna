require 'rails_helper'

feature 'User can delete question', %q{
  Authenticated user can delete question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create :question, author: user }

  context 'Authenticated user' do   
    scenario 'can delete question if he is author' do
      sign_in(user)
      visit questions_path
      click_on 'Delete'
      expect(page).to have_no_content 'MyText'
    end

    scenario "can't delete question if he is not author" do
      sign_in(other_user)
      visit questions_path
      expect(page).to have_no_link('Delete')
    end
  end

  scenario "Anathenticated user can't delete question" do
    visit questions_path
    expect(page).to have_no_link('Delete')
  end
end