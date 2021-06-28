require 'rails_helper'

feature 'Any user can view the list of questions', %q{
  In order to view the list of questions
  As an any user
  I'd like to be able list of the questions
} do
  given(:user) { create :user }
  given!(:questions) { create_list :question, 3, author: user }

  scenario 'Unauthenticated user can view the list of questions' do
    visit questions_path

    expect(page).to have_content "MyString", count: 3
    expect(page).to have_content "MyText", count: 3 
  end

  scenario 'Authenticated user can view the list of questions' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content "MyString", count: 3
    expect(page).to have_content "MyText", count: 3     
  end
end