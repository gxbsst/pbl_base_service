class Skills::Technique < PgConnection
  belongs_to :sub_category, :class_name => 'Skills::SubCategory'
  validates :title, presence: true
end
