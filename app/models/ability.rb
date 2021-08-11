# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user
  def initialize(user)
    @user = user
    if user 
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], author_id: user.id

    can [:like, :dislike], [Question, Answer] do |resource|
      !user.author_of?(resource)
    end

    cannot [:like, :dislike], [Question, Answer], author_id: user.id

    can :best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end

    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end

    can :index, Reward, id: user.id

    can [:me, :index], User, id: user.id

    can [:destroy], Api::V1::QuestionsController, id: user.id

    can [:create], Subscription

    can [:destroy], Subscription do |subscription|
      subscription.subscriber?(user)
    end
  end
end
