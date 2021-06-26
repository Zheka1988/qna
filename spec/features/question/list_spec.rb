require 'rails_helper'

feature 'User can view the list of questions', %q{
  In order to view the list of questions
  As an user
  I'd like to be able list of the questions
} do
  given!(:questions) { create_list :question, 3 }

  scenario 'User can view the list of questions' do
    visit questions_path

    expect(page).to have_content "MyString", count: 3
    expect(page).to have_content "MyText", count: 3 
  end
end