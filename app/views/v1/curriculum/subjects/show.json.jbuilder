json.extract! @clazz_instance, :id, :name
json.phases @clazz_instance.phases if params[:include] == 'phases'