require 'rails_helper'

feature 'User can create an answer to the question', %{
  In order to answer the question
  As an authenticated user
  I'd like to be able to create answer
} do
  given(:user) { create :user }
  given(:question) { create :question, author: user }

  context 'Authenticated user' do
    given(:user) { create :user }

    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries answer the question', js: true do
      within ".new-answer" do
        fill_in "Body", with: 'New answer'
        click_on "Reply"
      end
      expect(page).to have_content 'New answer'
    end

    scenario 'tries create answer with errors to the question', js: true do
      click_on "Reply"

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create a answer with attached file', js: true do
      within ".new-answer" do
        fill_in 'Body', with: 'New answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Reply'
      end
      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries answer the question' do
    visit question_path(question)
    fill_in "Body", with: 'New answer'
    click_on "Reply"
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe "multiple sessions" do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".new-answer" do
          fill_in 'Body', with: 'answer answer answer'
          click_on 'Reply'
        end
        within '.answers' do
          expect(page).to have_content 'answer answer answer'
        end

      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'answer answer answer'
        end
      end
    end
  end
end