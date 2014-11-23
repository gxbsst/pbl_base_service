
class User < ActiveRecord::Base

  # validates_confirmation_of :password
  # validates :email, :presence => true, :uniqueness => true, :email_format => true

  include Authentication

end