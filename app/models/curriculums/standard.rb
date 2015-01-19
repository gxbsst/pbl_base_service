class Curriculums::Standard < PgConnection
	validates :title, presence: true
	has_many :items, class_name: 'Curriculums::StandardItem', dependent: :destroy
	belongs_to :phase, class_name: 'Curriculums::Phase'
end