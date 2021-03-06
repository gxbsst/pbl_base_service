
class User < PgConnection
  include Surrounded

  validates_confirmation_of :password
  validates :email, :presence => true, :uniqueness => true, :email_format => true
  validates :username, :presence => true
  validates_uniqueness_of :username,  case_sensitive: false

  has_many :friend_ships
  has_many :follows

  has_many :friends, through: :friend_ships
  has_many :groups, class_name: 'Groups::Group', as: :owner
  belongs_to :school

  self.inheritance_column = :_type_disabled

  has_secure_password

  # after_create :create_invite, if: Proc.new {|user| user.type == 'Student'}
  #
  # def create_invite
  #   Invitation.create(owner_id: self.id, owner_type: self.class.name)
  # end

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