json.extract! @phase, :id, :name, :subject_id
json.curriculums @phase.standards if params[:include] == 'standards'

