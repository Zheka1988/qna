require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author).class_name('User') }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  context "choose_best_answer" do
    let!(:user) { create(:user) }
    let!(:question) { create :question, author: user }
    let!(:answer) { create :answer, question: question, author: user }
    let!(:answer2) { create :answer, question: question, author: user }

    it "change best answer" do
      answer.choose_best_answer
      expect(answer).to be_best
    end

    it "only one answer can be best" do
      answer.choose_best_answer
      answer2.choose_best_answer
      expect(question.answers.where(best: true).count).to eq 1
    end
  end

end
