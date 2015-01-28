class Todos::Todo < PgConnection

  has_many :recipients, class_name: 'Todos::Recipient'
end
