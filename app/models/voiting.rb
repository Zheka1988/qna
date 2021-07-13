class Voiting < ApplicationRecord
  belongs_to :user
  belongs_to :voitingable, polymorphic: true
  
  validates :user_id, uniqueness: { scope: [ :voitingable_type, :voitingable_id ] }
end
