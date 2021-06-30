require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let!(:answer) { create :answer, question: question, author: user }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(Answer, :count).by(1)
      end
      
      it 'the answer is related to the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create 
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end     
      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:other_user) { create(:user) }
    let!(:answer_false) { create :answer, question: question, author: other_user }

    context 'with valid attributes' do
      it 'changes the answer if logged user is author' do
        patch :update, params: { id: answer, answer: {body: 'new body'} }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'not changes the answer if logged user is not author' do
        expect do 
          patch :update, params: { id: answer_false, answer_false: {body: 'new body'} }, format: :js
        end.to_not change(answer_false, :body)
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: {body: 'new body'} }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'not changes the answer' do
        expect do 
          patch :update, params: { id: answer,  answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:answer) { create :answer, question: question, author: user }
    let!(:other_user) { create(:user) }
    let!(:answer_false) { create :answer, question: question, author: other_user  }

    it 'deletes the answer if logged user is author' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'deletes the answer if user is not author' do
      expect { delete :destroy, params: { id: answer_false } }.to_not change(Answer, :count)
    end

    it 'redirect to question show' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end
end
