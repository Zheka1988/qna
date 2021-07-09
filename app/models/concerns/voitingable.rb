module Voitingable
  extend ActiveSupport::Concern
  
  included do
    has_many :voitings, as: :voitingable,  dependent: :destroy
  end

  def sum_raiting
    voitings.sum(:raiting)
  end
end
