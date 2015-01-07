class CreatingAssignmentsScore

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
  end

  private

  def create_one(params = {})
    params = ActionController::Parameters.new(params).permit!
    score = Assignments::Score.new(params)

    unless score.save
      errors << score.errors
    end

   score
  end

  def create_many(params = [])
    params.each do |param|
      create_one(param)
    end

    self
  end

  class Error < Array; end
end