json.data do
  json.array! @collections do |item|
    json.technique_id item[0]
    json.gauges item[1]
  end
end

