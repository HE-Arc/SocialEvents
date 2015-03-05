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



events = []


events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 1, event_location_id: 1, title: "Viva Casa", category: 'Party hard', start_time: "2015-04-26", end_time: "2015-05-15",picture: 'http://i.imgur.com/uuuoqhW.jpg'  }
event_locations <<  { country: 'switzerland',name: "Casa dani", city: 'St-Imier', canton: 'Bern',cover: 'http://i.imgur.com/uuuoqhW.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '153',phone: '0795842654',website: 'www.google.ch' }

events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 1, event_location_id: 2, title: "Les amis du tricot", category: 'Decoration', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/RLe7blZ.jpg'  }
event_locations <<  { country: 'switzerland',name: "Chez carracio", city: 'St-Imier', canton: 'Neuchatel',cover: 'http://i.imgur.com/RLe7blZ.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }

events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 1, event_location_id: 3, title: "Halloween", category: 'Decoration', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/4G6VZ2I.jpg'  }
event_locations <<  { country: 'switzerland',name: "Fitzz", city: 'St-Imier', canton: 'Geneve',cover: 'http://i.imgur.com/4G6VZ2I.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }



User.create(users)
EventLocation.create(event_locations)
Event.create(events)
