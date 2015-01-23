
class PgConnection < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "#{Rails.env}".to_sym
end

ActiveRecord::Base.instance_eval do
  def using_object_ids?
    false
  end
end

