class Comment < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: :author_id
  
  belongs_to :commentable, polymorphic: true, touch: true
  validates :body, presence: true
end
