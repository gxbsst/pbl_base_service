class User < ActiveRecord::Base

  include ActiveUUID::UUID

  attr_accessor :first_name, :last_name

  scope :first, -> { order('created_at').first }
  scope :last, -> { order('created_at DESC').first }

end