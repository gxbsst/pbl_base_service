class ValidatingPassword

  def self.validate(listener, login, password)

    user = self.new(listener, login, password).validate
    if user
      listener.validate_on_success(user)
    else
      listener.validate_on_error('Not Found')
    end
  rescue Exception => e
    listener.validate_on_error('Not Found')
  end

  attr_accessor :listener, :login, :password

  def initialize(listener, login, password)
    @listener ||= listener
    @login ||= login
    @password ||= password

    @user = User.where(["lower(username) = :login OR lower(email) = :login", login: @login]).try(:first)

    @user.extend Authenticatable
  end

  def validate
    @user.validate(password)
  end

  module  Authenticatable
    def validate(password)
      authenticate(password)
    end
  end

end