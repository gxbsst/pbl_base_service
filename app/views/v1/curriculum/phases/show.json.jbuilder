json.extract! @phase, :id, :name, :subject_id
json.standards @phase.standards if params[:include] == 'standards'

