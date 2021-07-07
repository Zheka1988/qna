require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create :question, author: user}
  given(:gist_url) { 'https://gist.github.com/Zheka1988/4eac11b456aad48162ed4ed733685575' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in "Body", with: 'New answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on "Reply"

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end