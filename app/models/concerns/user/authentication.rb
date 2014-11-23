class User
  module Authentication
    extend ActiveSupport::Concern

    included do
      has_secure_password
    end

    module ClassMethods
      def authenticate(email, password)
        user = find_by_email(email)
        user if user && user.authenticate(password)
      end
    end
  end
end
