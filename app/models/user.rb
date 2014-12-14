
class User < PgConnection

  validates_confirmation_of :password
  validates :email, :presence => true, :uniqueness => true, :email_format => true

  # include Authentication

  has_secure_password

  class << self
    def find_by_login(login)
      if /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/.match(login)
        self.find(login) rescue nil
      else
        self.where(["username=:id OR email=:id", {id: login}]).try(:first) rescue nil
      end
    end
  end
end