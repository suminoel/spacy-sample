class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :user_name, :avatar, :leave_at
end
