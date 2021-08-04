require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' }  }


  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:user) { create :user }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      let!(:answers) { create_list :answer, 3, question: question, author: user }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    
    let(:user) { create :user }
    let!(:question) { create :question, author: user }
    let!(:link) { question.links.create(url: "http://example.com", name: "example") }
    let!(:comment) { question.comments.create(body: 'first_comment', author: user) }
    
    let(:file) { question.files.first }

    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"),
                  filename: 'spec_helper.rb', content_type: 'file/rb')
    end
    

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create :access_token }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns the question' do
        expect(json['question']['id']).to eq question.id
      end

      it 'return links of the question' do
        expect(json['question']['links'].first['name']).to eq link.name
      end

      it 'return comments of the question' do
        expect(json['question']['comments'].first['body']).to eq comment.body
      end

      it 'return only link for attached files' do
        name = question.files.first.filename
        
        expect(json['question']['files']["#{name}"]).to eq rails_blob_path(file)
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create :user }
    let!(:questions) { create_list :question, 3, author: user }
    let!(:question) { create :question, author: user }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{questions.first.id}" }
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      before { delete "/api/v1/questions/#{questions.first.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return deleted question' do
        expect(json['question']['body']).to eq questions.first.body
      end

      it 'deletes the question if logged user is author' do       
        expect{ delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }.to change(Question, :count).by(-1)
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { create :user }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions" }
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      before { post "/api/v1/questions", params: { access_token: access_token.token, question: attributes_for(:question)  }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'added question in db' do
        expect { post "/api/v1/questions", params: { access_token: access_token.token, question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do    
    let(:user) { create :user }
    let!(:question) { create :question, author: user }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create :access_token }

      before { patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, 
                                                                   question: { title: 'New Title', body: 'New Body' } }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'the question change body and title ' do
        question.reload
        expect(question.body).to eq 'New Body'
        expect(question.title).to eq 'New Title'
      end
    end
  end

end