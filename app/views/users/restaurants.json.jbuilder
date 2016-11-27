json.restaurants @restaurants do |r|
  json.id r.id

  json.name r.name
  json.description r.description

  json.phone r.phone
  json.picture r.picture
  json.address r.address

  json.latitude r.latitude
  json.longitude r.longitude

  json.time_open r.time_open
  json.time_closed r.time_closed

  json.general_estimated_seating_time general_estimated_seating_time(r)

  json.personal_estimated_seating_time personal_estimated_seating_time(r)

end
