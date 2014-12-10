  class Skills::SubCategory < PgConnection
    belongs_to :category
    has_many :techniques, class_name: 'Skills::Technique', dependent: :destroy
    validates :name, presence: true
  end
