json.extract! @curriculum, :id, :title, :phase_id
json.items @curriculum.items if params[:include] == 'items'

