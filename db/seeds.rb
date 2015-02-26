# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = []

for i in 1..10
  users <<  { email: "random#{i}@facebook.com", first_name: "Random#{i}", last_name: "Gugus#{i}" }
end


event_locations = []

for i in 1..10
  event_locations <<  { name: "Le bout du monde #{i}", city: 'St-Imier', canton: 'Bern' }
end


events = []

for i in 1..20
  user_id = i < 10 ? i : 1
  event_location_id = i % 10
  events <<  { user_id: user_id, event_location_id: event_location_id, title: "Rails and #{i} girls", category: 'Détente', start_time: "2015-02-26", end_time: "2015-03-15"  }
end


User.create(users)
EventLocation.create(event_locations)
Event.create(events)
