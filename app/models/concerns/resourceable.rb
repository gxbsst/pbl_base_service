module ResourceAble
  extend ActiveSupport::Concern

  included(base) do
   base.class_eval do
     has_many :resources, as: :owner
   end
  end

  module ClassMethods

  end
end