class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :question_id, :author_id, :best, :files
  has_many :links
  has_many :comments

  def files
    files = {}
    object.files.each do |file|
      files[file.filename.to_s] = rails_blob_path(file, only_path: true) 
      # files << rails_blob_path(file, only_path: true)
    end
    files
    
  end
end
