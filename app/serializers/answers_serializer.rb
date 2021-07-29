class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :create_at, :updated_at, :question_id, :author_id, :best
end
