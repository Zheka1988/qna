require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create :question, author: user }
  let(:reward) { create_ :reward, question: question }

  before { sign_in(user) }

  describe 'GET #index' do
    before { get :index }

    it 'return reward for the question' do
      expect(assigns(:reward)).to eq question.reward
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end
end
