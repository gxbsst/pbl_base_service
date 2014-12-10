json.extract! @phase, :id, :name, :curriculum_id
json.curriculums @phase.curriculums if params[:include] == 'standards'

