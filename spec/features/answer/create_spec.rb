require 'rails_helper'

feature 'User can create an answer to the question', %{
  In order to answer the question
  As an authenticated user
  I'd like to be able to create answer
} do
   
  given(:question) { create :question }

  context 'Authenticated user' do
    given(:user) { create :user }

    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries answer the question' do
      fill_in "Body", with: 'New answer'
      click_on "Reply"

      expect(page).to have_content 'New answer'
    end

    scenario 'tries create answer with errors to the question' do
      click_on "Reply"

      expect(page).to have_content "Your answer has not been published."
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries answer the question' do
    visit question_path(question)
    fill_in "Body", with: 'New answer'
    click_on "Reply"
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end