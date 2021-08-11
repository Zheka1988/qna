require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create :user }
  let!(:question) { create :question, author: user }

  describe 'POST #create' do
    before { login(user) }
    
    it 'saves a new subscription in the database' do
      expect { post :create, params: { question_id: question.id }, format: :js }.to change(Subscription, :count).by(1)
    end
  end


  describe 'DESLETE #destroy' do
    before { login(user) }
    let!(:subscription) { create :subscription, user: user, question: question }

    let!(:other_user) { create :user }
    let!(:false_subscription) {create :subscription, user: other_user, question: question } 

    it 'subscription creator can unsubscribe' do
      expect{ delete :destroy, params: { id: subscription.id }, format: :js }.to change(Subscription, :count).by(-1)
    end

    it 'unsubscribed user cannot delete the subscription' do
      expect{ delete :destroy, params: { id: false_subscription.id }, format: :js }.to_not change(Subscription, :count)
    end

  end
end
