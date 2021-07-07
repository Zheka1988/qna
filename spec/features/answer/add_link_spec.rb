require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create :question, author: user}
  given(:google) { "https://google.com" }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in "Body", with: 'New answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: google
    click_on "Reply"

    within '.answers' do
      expect(page).to have_link 'My gist', href: google
    end
  end
end