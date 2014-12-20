json.extract! @clazz_instance, :id, :title, :phase_id
json.items @clazz_instance.items if params[:include] == 'items'

