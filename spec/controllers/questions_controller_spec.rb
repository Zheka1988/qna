require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, author: user }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }
    before { get :index }

    it 'populates an array of all questions' do   
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns the new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do    
    before { login(user) }
    before { get :new }

    it 'assigns the new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns the new link for question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
    
    it 'assign a new reward @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      # expect(response).to render_template("questions/_edit")
      expect(response).to render_template :edit
    end    
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'as author with valid attribute' do      
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: "new title", body: "new body" }, format: :js }
        question.reload
        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end

      it 'render update view' do
        patch :update, params: { id: question, question: attributes_for(:question) , format: :js}
        expect(response).to render_template :update
      end
    end

    context "as author with invalid attribute" do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
      
      it 'does not changes question' do        
        question.reload
        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end

      it 'render update view' do
        expect(response).to render_template :update
      end
    end

    context 'as not author' do
      let!(:other_user) { create(:user) }
      let!(:other_question) { create :question, author: other_user }

      it 'attempt change question' do
        patch :update, params: { id: other_question, other_question: { body: "new body" } }, format: :js
        expect(response.status).to eq 403
      end

      it 'question attribute not change' do
        expect do
          patch :update, params: { id: other_question, other_question: { body: "new body" } }, format: :js
        end.to_not change(other_question, :body)
      end
    end
  end

  describe "DELETE #destroy" do
    before { login(user) }
    
    let!(:question) { create :question, author: user }
    let!(:other_user) { create(:user) }
    let!(:question_false) { create :question, author: other_user }

    it 'deletes the question if logged user is author' do
      expect{ delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'deletes the question if logged user is not author' do
      expect{ delete :destroy, params: { id: question_false } }.to_not change(Question, :count)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

  describe 'POST #like' do
    before { login(user) }
    context 'author' do
      let!(:question) { create(:question, author: user) }

      it 'can not voiting like the question' do
        post :like, params: { id: question }, format: :js
        expect(response).to render_template :index
      end
    end

    context 'not author' do
      let!(:other_user) { create(:user) }
      let!(:other_question) { create :question, author: other_user }

      it 'can voiting like the question' do
        post :like, params: { id: other_question }, format: :js
        other_question.reload
        expect(other_question.sum_raiting).to eq 1
      end
    end
  end

  describe 'POST #dislike' do
    before { login(user) }
    context 'author' do
      let!(:question) { create(:question, author: user) }

      it 'can not voiting dislike the question' do
        post :dislike, params: { id: question }, format: :js
        expect(response).to render_template :index
      end
    end

    context 'not author' do
      let!(:other_user) { create(:user) }
      let!(:other_question) { create :question, author: other_user }

      it 'can voiting dislike the question' do
        post :dislike, params: { id: other_question }, format: :js
        other_question.reload
        expect(other_question.sum_raiting).to eq -1
      end
    end
  end
end
