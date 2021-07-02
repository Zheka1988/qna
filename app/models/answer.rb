class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: :author_id

  validates :body, presence: true

  def choose_best_answer
    transaction do
      question.answers.where(best: true).update(best: false)
      update!(best: true)
    end
  end
end
