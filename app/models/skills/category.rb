module Skills
  class Category < PgConnection
    self.table_name = 'skill_categories'

    belongs_to :skill
    has_many :techniques, class_name: 'Skills::Technique', dependent: :destroy
    validates :name, presence: true
  end
end