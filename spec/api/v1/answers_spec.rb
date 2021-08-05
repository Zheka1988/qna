require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' }  }

  let(:user) { create :user }
  let!(:question) { create :question, author: user }
  
  describe 'GET /api/v1/questions/:id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:answers) { create_list :answer, 3, question: question, author: user }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at best question_id author_id].each do |attr|
          expect(json['answers'].first[attr]).to eq answers.first.send(attr).as_json
        end
      end

      it 'all answers belong to the question' do
        id_s = []
        json['answers'].each  {  |answer| id_s << answer['question_id'].to_i }
        expect(id_s.inject(:+)).to eq question.id * 3
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create :answer, question: question, author: user }
    let!(:link) { answer.links.create(url: "http://example.com", name: "example") }
    let!(:comment) { answer.comments.create(body: 'first_comment', author: user) }
    let(:file) { answer.files.first }

    before do
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"),
                  filename: 'spec_helper.rb', content_type: 'file/rb')
    end
    
    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :get }
    end

    context "authorized" do
      let(:access_token) { create :access_token }
      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns the answer' do
        expect(json['answer']['id']).to eq answer.id
      end

      it 'return links of the answer' do
        expect(json['answer']['links'].first['name']).to eq link.name
      end

      it 'return comments of the answer' do
        expect(json['answer']['comments'].first['body']).to eq comment.body
      end

      it 'return only link for attached files' do
        name = answer.files.first.filename

        expect(json['answer']['files']["#{name}"]).to eq rails_blob_path(file)
      end

    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create :user }
    let!(:question) { create :question, author: user }
    let!(:answers) { create_list :answer, 3, question: question, author: user }
    let!(:answer) { create :answer, question: question, author: user }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answers.first.id}" }
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      before { delete "/api/v1/answers/#{answers.first.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return deleted question' do
        expect(json['answer']['body']).to eq answers.first.body
      end

      it 'deletes the question if logged user is author' do       
        expect{ delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }.to change(Answer, :count).by(-1)
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:user) { create :user }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      before { post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, answer: attributes_for(:answer)  }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'added question in db' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do    
    let(:user) { create :user }
    let!(:question) { create :question, author: user }
    let!(:answer) { create :answer, question: question, author: user }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create :access_token }

      before { patch "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token, 
                                                                   answer: { body: 'New Body' } }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'the question change body and title ' do
        answer.reload
        expect(answer.body).to eq 'New Body'
      end
    end
  end
end