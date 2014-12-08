json.extract! @subject, :id, :name
json.phases @subject.phases if params[:include] == 'phases'