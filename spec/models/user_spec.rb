require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  
  it { should have_many(:authored_answers) }
  it { should have_many(:authored_questions) }

  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe "Method author_of?" do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:other_user) { create :user }
    let(:other_question) { create :question, author: other_user }
    
    it { expect(user.author_of?(question)).to eq true }
    it { expect(user.author_of?(other_question)).to eq false }
  end

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('MyServices::FindForOauth')}

    it 'cals MyServices::FindForOauth' do
      expect(MyServices::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end   
  end
end
