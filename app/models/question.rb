class Question < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: :author_id
  has_many :answers, dependent: :destroy

  has_one_attached :file

  validates :title, :body, presence: true
end
