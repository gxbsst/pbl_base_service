json.extract! @clazz_instance, :id, :name, :subject_id
json.standards @clazz_instance.standards if params[:include] == 'standards'

