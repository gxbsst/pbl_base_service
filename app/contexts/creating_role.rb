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
    case params.class
    when Array
      params.each do |param|
        user_id = param.delete(:user_id)
        create_one(param)
      end
    when Hash
      user_id = params.delete(:user_id)
      create_one(params)
    end

    def create_one(params)
      
    end
  end
end