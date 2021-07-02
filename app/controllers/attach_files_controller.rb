class AttachFilesController < ApplicationController

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    if current_user.author_of?(@file.record)
      @file.purge
      redirect_to render_page(@file)
    else
      head :forbidden
    end
  end

  def render_page(file)
    if file.record_type == "Question"
      file.record
    elsif file.record_type == "Answer"
      file.record.question
    end
  end
end