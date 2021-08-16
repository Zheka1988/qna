require 'rails_helper'

RSpec.describe SearchEnginesController, type: :controller do
  let(:users) { create_list :user, 3}
  let(:questions) { create_list :question, 3, author: users.first }
  let(:answers) { create_list :answer, 3, question: questions.first, author: users.first }
  let(:comments) { create_list :comment, 3, commentable_type: 'Question', commentable_id: questions.first.id }

  describe 'GET #search' do
    it 'user can find question or answer or comment or user' do
      
    end
    
    it 'user can search all objects' do
      
    end

  end
end
