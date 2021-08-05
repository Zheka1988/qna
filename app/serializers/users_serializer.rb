class UsersSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :created_at, :updated_at
end
