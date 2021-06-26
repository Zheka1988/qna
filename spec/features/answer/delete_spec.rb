require 'rails_helper'

feature 'User can delete answer', %q{
  Authenticated user can delete answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }

  context 'Authenticated user' do   
    scenario 'can delete answer if he is author' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete'
      expect(page).to have_content 'MyText', count: 1
    end

    scenario "can't delete answer if he is not author" do
      sign_in(other_user)
      visit question_path(question)
      expect(page).to have_no_link('Delete')
    end
  end

  scenario "Anathenticated user can't delete answer" do
    visit question_path(question)
    expect(page).to have_no_link('Delete')
  end
end