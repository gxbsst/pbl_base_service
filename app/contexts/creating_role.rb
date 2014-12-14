class CreatingRole
  def self.create(listener, params = {})
    self.new(listener, params).create
  end

  attr_reader :listener, :params, :user_id
  def initialize(listener, params)
    @listener = listener
    if params.is_a? Array
      @user_id = params[0].delete([:user_id])
    else
      @user_id = params.delete(:user_id)
      @params = params
    end
  end

  def create
    Role.create(params)
  end
end