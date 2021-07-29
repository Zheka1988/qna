require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' }  }

  let(:user) { create :user }
  let(:question) { create :question, author: user }
  
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
        expect(json.size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at best question_id author_id].each do |attr|
          expect(json.first[attr]).to eq answers.first.send(attr).as_json
        end
      end

      it 'all answers belong to the question' do
        id_s = []
        json.each  {  |answer| id_s << answer['question_id'].to_i }
        expect(id_s.inject(:+)).to eq question.id * 3
      end
    end
  end
end