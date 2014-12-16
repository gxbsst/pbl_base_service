class CreatingAssignment
  def self.create(listener, params = {})
    self.new(listener, params).create
  end

  attr_reader :listener, :params, :errors
  def initialize(listener, params)
    @listener = listener
    @params = params
    @errors = Errors.new
  end

  def create
    if params.is_a? Array
      params.each do |param|
        create_one(param)
      end
    elsif params.is_a? Hash
      create_one(params)
    end
    listener.create_on_success(errors)
    self
  end

  def create_one(params)
    user_id = params.delete(:user_id)
    fail 'Without user_id' unless user_id

    create_users_role(find_a_role(build_params(params)), user(user_id))
  end

  def create_users_role(role, user)

    user.has_role?(role) do |user_role|

      if user_role.blank?
        UsersRole.create(user_id: user.id, role_id: role.id)
      else
        errors << { user.id => 'role dose exist'}
      end
    end
  end

  private

  def user(user_id)
    user = User.find(user_id)
    user.extend RoleHelper
    user
  end

  def build_params(params)
    if params.is_a? Hash
      params = ActionController::Parameters.new(params)
    end
    params
  end

  def find_a_role(params)
    role = Role.find_or_initialize_by(params.permit!)
    role.save if role.new_record?
    role
  end

  module RoleHelper
    def has_role?(role)
      yield UsersRole.where(user_id: self.id, role_id: role.id).try(:first)
    end
  end

  class Errors < Array

  end
end