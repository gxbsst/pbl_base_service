class Pbls::StandardItem < PgConnection
  belongs_to :project
  belongs_to :standard_item, class_name: 'Curriculums::StandardItem'
end
