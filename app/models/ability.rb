# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user
  def initialize(user)
    @user = user
    if user 
      user.admin? ? admin_abilities : user_abilities
    else
      quest_abilities
    end
  end

  def quest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    quest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], author: user
    can [:like, :dislike], Question, Question do |question|
      !(user.author_of?(question))
    end
    cannot [:like, :dislike], Question, author: user
    
    can [:like, :dislike], Answer, Answer do |answer|
      !(user.author_of?(answer))
    end
    cannot [:like, :dislike], Answer, author: user

    can :best, Answer, Answer do |answer|
      user.author_of?(answer.question)
    end
  end
end
