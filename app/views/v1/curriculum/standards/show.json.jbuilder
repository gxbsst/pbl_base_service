json.extract! @standard, :id, :title, :phase_id
json.items @standard.items if params[:include] == 'items'

