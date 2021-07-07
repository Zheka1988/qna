require 'rails_helper'

feature 'Author the question can shoose the best answer', %q{
  being on the question page,
  author can shoose, which answer is better
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  
  given(:question) { create(:question, author: user) }
  given!(:reward) { create(:reward, question: question) }
  given!(:answer) { create_list(:answer, 3, question: question, author: other_user) }

  scenario 'Unauthenticated user can not shoose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best Answer' 
  end

  describe 'Authenticated user' do
    scenario 'author question, can choose best Answer', js: true do
      sign_in(user)
      
      visit question_path(question)
      id_for_click = '#answer-' + Answer.second.id.to_s

      within id_for_click do
        click_on 'Best'
      end

      element = first('.answers')
      expect(element).to have_content Answer.second.body
    end

    scenario 'not author question, can not shoose best answer' do
      sign_in other_user
      
      visit question_path(question)

      expect(page).to_not have_link 'Best Answer' 
    end
  end
end