class Notification < PgConnection
  self.inheritance_column = :_type_disabled
end
