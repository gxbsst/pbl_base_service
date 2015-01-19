class Pbls::Technique < PgConnection
  belongs_to :project
  belongs_to :technique, class_name: 'Skills::Technique'


  after_save :index_searcher

  # NOTE:
  #    GATEWAY DO THE INDEX
  def index_searcher
    technique = Skills::Technique.includes(sub_category: [:category]).find(self.technique_id)
    category_name = technique.sub_category.category.name

    searcher = Pbls::Searcher.find_or_initialize_by(project_id: self.project_id)
    searcher.technique = category_name

    searcher.save!
  end
end
