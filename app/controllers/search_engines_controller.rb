class SearchEnginesController < ApplicationController
  
  def search
    authorize! :search, current_user 
    
    @classes = { "Question" => 1, "Answer" => 2, "Comment" => 3, "User" => 4 }

    if params["find"] == "All"
      @search_rezult = ThinkingSphinx.search params["search"]
    elsif [ "Questions", "Answers", "Users", "Comments" ].include? params["find"]
      @search_rezult = params["find"].classify.constantize.search params["search"]
    end
  end

end
