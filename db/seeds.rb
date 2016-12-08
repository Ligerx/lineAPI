# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

jsonString = '{"restaurants":[{"name":"Union Grill","description":"Bustling spot popular with the college crowd & known for piled-high burgers & waffle-cut fries.","phone":"(412) 681-8620","picture":"http://theuniongrill.com/wp-content/uploads/2012/09/banner2.jpg","address":"413 S Craig St, Pittsburgh, PA 15213","latitude":40.444835,"longitude":-79.948529,"time_open":"11:30am","time_closed":"10pm","num_tables":2},{"name":"The Porch","description":"Sunny bistro for gourmet pizzas, burgers & more with a counter service lunch & full service dinner.","phone":"(412) 687-6724","picture":"https://media-cdn.tripadvisor.com/media/photo-s/02/d8/2f/12/the-porch-at-schenley.jpg","address":"221 Schenley Drive, Pittsburgh, PA 15213","latitude":40.442758,"longitude":-79.953102,"time_open":"11am","time_closed":"11pm","num_tables":30},{"name":"Rose Tea Cafe","description":"Nothing-fancy eatery offering a variety of traditional Chinese recipes.","phone":"(412) 802-0788","picture":"https://s3-media4.fl.yelpcdn.com/bphoto/X6p3LrwVGtO5rQnmBZIYNg/ls.jpg","address":"416 S Craig St, Pittsburgh, PA 15213","latitude":40.444835,"longitude":-79.948529,"time_open":"11am","time_closed":"9pm","num_tables":5}],"users":[{"first_name":"Alex","last_name":"Wang","email":"awang1@andrew.cmu.edu","password":"password","phone":"1234567890"},{"first_name":"RhoEun","last_name":"Song","email":"rhoeuns@andrew.cmu.edu","password":"password","phone":"1234567890"},{"first_name":"User","last_name":"Three","email":"user3@andrew.cmu.edu","password":"password","phone":"1234567890"},{"first_name":"User","last_name":"Four","email":"user4@andrew.cmu.edu","password":"password","phone":"1234567890"},{"first_name":"User","last_name":"Five","email":"user5@andrew.cmu.edu","password":"password","phone":"1234567890"}]}'
json = ActiveSupport::JSON.decode(jsonString)

restaurant1 = Restaurant.new(json["restaurants"][0])
restaurant1.beaconUUID = "b9407f30-f5f8-466e-aff9-25556b57fe6d"
restaurant1.save

restaurant2 = Restaurant.new(json["restaurants"][1])
restaurant2.beaconUUID = "b9407f30-f5f8-466e-aff9-25556b57fe6d"
restaurant2.save

restaurant3 = Restaurant.new(json["restaurants"][2])
restaurant3.beaconUUID = "fakeUUID"
restaurant3.save

user1 = User.create(json["users"][0])
user2 = User.create(json["users"][1])
user3 = User.create(json["users"][2])
user4 = User.create(json["users"][3])
user5 = User.create(json["users"][4])

# reservation1 = Reservation.create(json["reservations"][0])
# reservation1.user = user1
# reservation1.restaurant = restaurant1
# reservation1.save
#
# reservation2 = Reservation.create(json["reservations"][1])
# reservation2.user = user2
# reservation2.restaurant = restaurant2
# reservation2.save
#
# reservation3 = Reservation.create(json["reservations"][2])
# reservation3.user = user1
# reservation3.restaurant = restaurant2
# reservation3.save


=begin
One person is seated here
For demonstration purposes, what I might do is show the wait
time with 1 person seated.

Then have someone else make a reservation, showing the updated wait
time left till the first person leaves.

Then I can put myself in line, which gives me the wait time of the first table.

Finally, I can cancel the first reservation, leaving me standing in
line for the open table, so no wait time.
=end
reservation1 = Reservation.new()
reservation1.user = user3
reservation1.restaurant = restaurant1
reservation1.party_size = 4
reservation1.time_reserved = 1.hour.ago
reservation1.time_seated = 45.minutes.ago
reservation1.save!


#####   This is the sample JSON used in the seed   #####
# {
#   "restaurants":[
#     {
#       "name":"Union Grill",
#       "description":"Bustling spot popular with the college crowd & known for piled-high burgers & waffle-cut fries.",
#       "phone":"(412) 681-8620",
#       "picture":"http://theuniongrill.com/wp-content/uploads/2012/09/banner2.jpg",
#       "address":"413 S Craig St, Pittsburgh, PA 15213",
#       "latitude":40.444835,
#       "longitude":-79.948529,
#       "time_open":"11:30am",
#       "time_closed":"10pm",
#       "num_tables":2
#     },
#     {
#       "name":"The Porch",
#       "description":"Sunny bistro for gourmet pizzas, burgers & more with a counter service lunch & full service dinner.",
#       "phone":"(412) 687-6724",
#       "picture":"https://media-cdn.tripadvisor.com/media/photo-s/02/d8/2f/12/the-porch-at-schenley.jpg",
#       "address":"221 Schenley Drive, Pittsburgh, PA 15213",
#       "latitude":40.442758,
#       "longitude":-79.953102,
#       "time_open":"11am",
#       "time_closed":"11pm",
#       "num_tables":30
#     },
#     {
#       "name":"Rose Tea Cafe",
#       "description":"Nothing-fancy eatery offering a variety of traditional Chinese recipes.",
#       "phone":"(412) 802-0788",
#       "picture":"https://s3-media4.fl.yelpcdn.com/bphoto/X6p3LrwVGtO5rQnmBZIYNg/ls.jpg",
#       "address":"416 S Craig St, Pittsburgh, PA 15213",
#       "latitude":40.444835,
#       "longitude":-79.948529,
#       "time_open":"11am",
#       "time_closed":"9pm",
#       "num_tables":5
#     }
#   ],
#   "users":[
#     {
#       "first_name":"Alex",
#       "last_name":"Wang",
#       "email":"awang1@andrew.cmu.edu",
#       "password":"password",
#       "phone":"1234567890"
#     },
#     {
#       "first_name":"RhoEun",
#       "last_name":"Song",
#       "email":"rhoeuns@andrew.cmu.edu",
#       "password":"password",
#       "phone":"1234567890"
#     },
#     {
#       "first_name":"User",
#       "last_name":"Three",
#       "email":"user3@andrew.cmu.edu",
#       "password":"password",
#       "phone":"1234567890"
#     },
#     {
#       "first_name":"User",
#       "last_name":"Four",
#       "email":"user4@andrew.cmu.edu",
#       "password":"password",
#       "phone":"1234567890"
#     },
#     {
#       "first_name":"User",
#       "last_name":"Five",
#       "email":"user5@andrew.cmu.edu",
#       "password":"password",
#       "phone":"1234567890"
#     }
#   ]
# }
