require 'rails_helper'
include Rails.application.routes.url_helpers

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' }  }

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
    let!(:file) { question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"),
                  filename: 'spec_helper.rb', content_type: 'file/rb') }

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
        expect(json['question']['files'][name]).to eq rails_blob_path(file, only_path: true)
      end
    end
  end
end