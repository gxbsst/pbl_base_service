class CreatingGroup
  def self.create(listener, params, options = {})
    new(listener, params, options).create
  end

  attr_reader :listener, :creator, :params, :owner_id, :owner_type
  def initialize(listener, params, options = {})
    @listener = listener
    @params = ActionController::Parameters.new(params)
    @options = options
    @creator  = Object.new.extend Creator
    @owner_id = params.fetch(:owner_id)
    @owner_type = params.fetch(:owner_type)
  end

  def create
   @creator.create_group(params) do |group|
     if group.valid?
       # if owner_type.downcase == 'user'
       #   Groups::MemberShip.create(user_id: owner_id, group_id: group.id, role: ['creator'])
       # end
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