json.extract! @sub_category, :id, :name, :category_id
json.techniques @sub_category.techniques if params[:include] == 'techniques'

