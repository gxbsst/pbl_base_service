json.extract! @phase, :id, :name, :subject_id
json.curriculums @phase.curriculums if params[:include] == 'standards'

