class LinksController < ApplicationController
  before_action :load_link, only: [:destroy]

  def destroy
    if current_user.author_of?(@model)
      @link.destroy
    else
      flash[:notice] = "Only author can delete the link for the question!"
    end
  end

  private
  def load_link
    @link = Link.find(params[:id])
    load_link_model
  end

  def load_link_model
    @model = @link.linkable
  end
end
