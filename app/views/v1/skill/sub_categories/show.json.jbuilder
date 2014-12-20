json.extract! @clazz_instance, :id, :name, :category_id
json.techniques @clazz_instance.techniques if params[:include] == 'techniques'

