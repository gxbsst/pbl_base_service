json.extract! @category, :id, :name, :skill_id
json.techniques @category.techniques if params[:include] == 'techniques'

