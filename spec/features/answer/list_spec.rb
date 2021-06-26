require 'rails_helper'

feature 'User can view the list answers', %q{
  In order to find the answer to the question
  As an any user
  I'd like to be able list of the answers
}do
  given(:question) { create :question }
  given!(:answers) { create_list :answer, 3, question: question}
  given(:user) { create :user }

  scenario 'Unauthenticated user can view the list of answers' do
    visit question_path(question)

    expect(page).to have_content "MyText", count: 4 
  end

  scenario 'Authenticated user can view the list of answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content "MyText", count: 4     
  end   
end
