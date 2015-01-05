class CreatingAssignmentsWork

  def self.create(listener, params, options = {})
   new(listener, params, options).create
  end

  attr_reader :listener, :params, :options, :errors

  def initialize(listener, params, options = {})
    @listener = listener
    @params = params
    @options = options
    @errors = Error.new
  end

  def create
    if params.is_a? Hash
      create_one(params)
    elsif params.is_a? Array
      create_many(params)
    end

    if errors.count > 0
      listener.on_create_error(errors)
    else
      listener.on_create_success
    end

    self
    # task_id = params.fetch(:task_id)
    # task_type = params.fetch(:task_type)
    # sender_id = params.fetch(:sender_id)
    # acceptor_id = params.fetch(:acceptor_id)
    # acceptor_type = params.fetch(:acceptor_type)
  end

  private

  def create_one(params = {})
    params = ActionController::Parameters.new(params).permit!
    work = Assignments::Work.new(params)

    unless work.save
      errors << work.errors
    end

    work
  end

  def create_many(params = [])
    params.each do |param|
      create_one(param)
    end

    self
  end

  class Error < Array; end
end