json.extract! @clazz_instance, :id, :name
json.sub_categories @clazz_instance.sub_categories if params[:include] == 'sub_categories'

