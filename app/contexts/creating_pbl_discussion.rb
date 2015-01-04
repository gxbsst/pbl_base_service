class CreatingPblDiscussion
  def self.create(listener, params, options = {})
    new(listener, params, options).create
  end

  def self.create_many(listener, params, options = {})
    new(listener, params, options).create_one
  end

  attr_reader :listener, :params, :options, :error
  def initialize(listener, params, options = {})
    @listener = listener
    @params = params
    @options = options
    @error = Errors.new
  end

  def create
    if params.is_a? Hash
      create_one(params)
    elsif params.is_a? Array
      create_many(params)
    end

    if error.count > 0
      listener.on_create_error(error)
    else
      listener.on_create_success
    end

    self
  end

  private

  def create_one(params = {})
    members = params.delete(:members)
    params = ActionController::Parameters.new(params).permit!
    discussion = Pbls::Discussion.new(params)

    if discussion.save
      create_members(discussion, members)
    else
      error << discussion.errors
    end

    discussion
  end

  def create_members(discussion, members = [])
    if members.present?
      members.each do |user_id|
        Pbls::DiscussionMember.create(user_id: user_id, discussion_id: discussion.id)
      end
    end

    self
  end

  def create_many(params = [])
    params.each do |param|
      create_one(param)
    end

    self
  end

  class Errors < Array

  end

end