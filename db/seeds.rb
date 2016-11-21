# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

jsonString = '{"restaurants":[{"name":"Union Grill","description":"Bustling spot popular with the college crowd & known for piled-high burgers & waffle-cut fries.","phone":"(412) 681-8620","picture":"http://theuniongrill.com/wp-content/uploads/2012/09/banner2.jpg","address":"413 S Craig St, Pittsburgh, PA 15213","latitude":40.444835,"longitude":-79.948529,"time_open":"11:30am","time_closed":"10pm","num_tables":16},{"name":"The Porch","description":"Sunny bistro for gourmet pizzas, burgers & more with a counter service lunch & full service dinner.","phone":"(412) 687-6724","picture":"https://media-cdn.tripadvisor.com/media/photo-s/02/d8/2f/12/the-porch-at-schenley.jpg","address":"221 Schenley Drive, Pittsburgh, PA 15213","latitude":40.442758,"longitude":-79.953102,"time_open":"11am","time_closed":"11pm","num_tables":30}],"users":[{"first_name":"Alex","last_name":"Wang","email":"awang1@andrew.cmu.edu","password":"password","phone":"1234567890"},{"first_name":"RhoEun","last_name":"Song","email":"rhoeuns@andrew.cmu.edu","password":"password","phone":"1234567890"}],"reservations":[{"party_size":4,"time_reserved":"2016/11/18 20:14","time_seated":"2016/11/18 20:42","time_left":"2016/11/18 21:35","cancelled":false},{"party_size":2,"time_reserved":"2016/11/18 21:30","time_seated":"2016/11/18 21:36","time_left":null,"cancelled":false},{"party_size":1,"time_reserved":"2016/11/19 12:25","time_seated":null,"time_left":null,"cancelled":false}]}'
json = ActiveSupport::JSON.decode(jsonString)

restaurant1 = Restaurant.create(json["restaurants"][0])
restaurant2 = Restaurant.create(json["restaurants"][1])

user1 = User.create(json["users"][0])
user2 = User.create(json["users"][1])

reservation1 = Reservation.create(json["reservations"][0])
reservation1.user = user1
reservation1.restaurant = restaurant1
reservation1.save

reservation2 = Reservation.create(json["reservations"][1])
reservation2.user = user2
reservation2.restaurant = restaurant2
reservation2.save

reservation3 = Reservation.create(json["reservations"][2])
reservation3.user = user1
reservation3.restaurant = restaurant2
reservation3.save



#####   This is the sample JSON used in the seed   #####
# {
#   "restaurants": [
#     {
#       "name": "Union Grill",
#       "description": "Bustling spot popular with the college crowd & known for piled-high burgers & waffle-cut fries.",
#       "phone": "(412) 681-8620",
#       "picture": "http://theuniongrill.com/wp-content/uploads/2012/09/banner2.jpg",
#       "address": "413 S Craig St, Pittsburgh, PA 15213",
#       "latitude": 40.444835,
#       "longitude": -79.948529,
#       "time_open": "11:30am",
#       "time_closed": "10pm",
#       "num_tables": 16
#     },
#     {
#       "name": "The Porch",
#       "description": "Sunny bistro for gourmet pizzas, burgers & more with a counter service lunch & full service dinner.",
#       "phone": "(412) 687-6724",
#       "picture": "https://media-cdn.tripadvisor.com/media/photo-s/02/d8/2f/12/the-porch-at-schenley.jpg",
#       "address": "221 Schenley Drive, Pittsburgh, PA 15213",
#       "latitude": 40.442758,
#       "longitude": -79.953102,
#       "time_open": "11am",
#       "time_closed": "11pm",
#       "num_tables": 30
#     }
#   ],
#   "users": [
#     {
#       "first_name": "Alex",
#       "last_name": "Wang",
#       "email": "awang1@andrew.cmu.edu",
#       "password": "password",
#       "phone": "1234567890"
#     },
#     {
#       "first_name": "RhoEun",
#       "last_name": "Song",
#       "email": "rhoeuns@andrew.cmu.edu",
#       "password": "password",
#       "phone": "1234567890"
#     }
#   ],
#   "reservations": [
#     {
#       "party_size": 4,
#       "time_reserved": "2016/11/18 20:14",
#       "time_seated": "2016/11/18 20:42",
#       "time_left": "2016/11/18 21:35",
#       "cancelled": false
#     },
#     {
#       "party_size": 2,
#       "time_reserved": "2016/11/18 21:30",
#       "time_seated": "2016/11/18 21:36",
#       "time_left": null,
#       "cancelled": false
#     },
#     {
#       "party_size": 1,
#       "time_reserved": "2016/11/19 12:25",
#       "time_seated": null,
#       "time_left": null,
#       "cancelled": false
#     }
#   ]
# }
