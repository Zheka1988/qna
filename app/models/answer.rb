class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: :author_id
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files
  
  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def choose_best_answer
    transaction do
      question.answers.where(best: true).update(best: false)
      update!(best: true)
    end
  end
end
