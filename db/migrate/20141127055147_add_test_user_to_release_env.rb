class AddTestUserToReleaseEnv < ActiveRecord::Migration
  if Rails.env=='release'
    def up
      User.create(
        username: 'test',
        email: 'test@edutec.com',
        password: 'test'
      )
    end

    def down
      User.find_by_email('test@edutec.com').destroy
    end
  end
end
