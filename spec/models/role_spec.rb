require 'rails_helper'

RSpec.describe Role, :type => :model do
  it { expect(described_class.new).to validate_presence_of(:name) }
  it { expect(described_class.new).to have_and_belong_to_many(:users) }

  it "create a role" do
    user = User.create(username: 'username', email: '222@gmail.com', password: 'password')
    resource = Pbls::Project.create
    role = Role.create(name: 'name', resource_type: 'Project', resource_id: resource.id)
    users_role = UsersRole.create(user_id: user.id, role_id: role.id)

    expect(role.users.first).to eq(user)
  end
end
