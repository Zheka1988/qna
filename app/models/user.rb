class User < ApplicationRecord
  has_many :authored_answers, class_name: 'Answer', foreign_key: :author_id
  has_many :authored_questions, class_name: 'Question', foreign_key: :author_id
  has_many :voitings
  has_many :comments
  has_many :subscription, dependent: :destroy

  has_many :authorizations, dependent: :destroy
  
  has_many :rewards, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :facebook]

  def author_of?(resource)
    self.id == resource.author_id
  end

  def self.find_for_oauth(auth)
    MyServices::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed?(question)
    Subscription.find_by(user_id: self.id, question_id: question.id) ? true : false
  end
end
