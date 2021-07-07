require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create :question, author: user }
  let!(:link) { question.links.create(url: "http://example.com", name: "example") }

  before { sign_in(user) }

  describe "GET #destroy" do

    it "delete link" do
      expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.to change(question.links, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: question.links.first.id }, format: :js
      expect(response).to render_template :destroy
    end

  end
end
