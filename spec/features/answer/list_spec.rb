require 'rails_helper'

feature 'User can view the list answers', %q{
  In order to find the answer to the question
  As an any user
  I'd like to be able list of the answers
}do
  given(:user) { create :user } 
  given(:question) { create :question, author: user }
  given!(:answers) { create_list :answer, 3, question: question, author: user }
 

  scenario 'Unauthenticated user can view the list of answers' do
    visit question_path(question)

    expect(page).to have_content "MyAnswer", count: 3 
  end

  scenario 'Authenticated user can view the list of answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content "MyAnswer", count: 3     
  end   
end
