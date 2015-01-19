# encoding: utf-8

class Pbls::StandardItem < PgConnection
  belongs_to :project
  belongs_to :standard_item, class_name: 'Curriculums::StandardItem'

  after_save :index_searcher

  # NOTE:
  #    GATEWAY DO THE INDEX
  def index_searcher
    curr_standard_item =  Curriculums::StandardItem.includes(standard: [phase: [:subject]]).find(self.standard_item_id)
    subject_name = curr_standard_item.standard.phase.subject.name
    phase_name = curr_standard_item.standard.phase.name

    searcher = Pbls::Searcher.find_or_initialize_by(project_id: self.project_id)
    searcher.subject = subject_name
    searcher.phase = phase_name

    searcher.save!
  end
end
