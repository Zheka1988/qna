class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question
  
  validates_uniqueness_of :user_id, scope: :question_id
end
