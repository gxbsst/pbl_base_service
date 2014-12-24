class CreatingGroup
  def self.create(listener, params, options = {})
    new(listener, params, options).create
  end

  attr_reader :listener, :creator, :params
  def initialize(listener, params, options = {})
    @listener = listener
    @creator  =  User.find(params[:user_id]).extend Creator
    @params = ActionController::Parameters.new(params)
  end

  def create
   @creator.create_group(params) do |group|
     if group.valid?
       Groups::MemberShip.create(user_id: creator.id, group_id: group.id, role: ['creator'])
       listener.on_create_success(group)
     else
       listener.on_create_error(group)
     end
   end
  end

  module Creator
    def create_group(params)
      group = Groups::Group.create(params.permit!)
      yield group if block_given?
      self
    end
  end
end