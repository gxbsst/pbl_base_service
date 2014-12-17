module Resourceable
  extend ActiveSupport::Concern

  included do
     has_many :resources, as: :owner
  end

  module ClassMethods

  end
end