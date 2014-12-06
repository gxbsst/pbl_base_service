json.extract! @skill, :id, :title
json.categories @skill.categories if params[:include] == 'categories'

