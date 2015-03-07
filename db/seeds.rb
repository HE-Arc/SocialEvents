# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = []
event_locations = []
events = []

users <<  { email: "caraccio@facebook.com", first_name: "Michael", last_name: "Carraccio" }
users <<  { email: "deruaz@facebook.com", first_name: "Vincent", last_name: "Deruaz" }
users <<  { email: "Rossert@facebook.com", first_name: "Mathieu", last_name: "Rossert" }
users <<  { email: "LeGredin@facebook.com", first_name: "Kilian", last_name: "LeGredin" }
users <<  { email: "Hugedwarf@facebook.com", first_name: "Nicolas", last_name: "Hugedwarf" }


events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 1, event_location_id: 1, title: "Viva Casa", category: 'Party hard', start_time: "2015-04-26", end_time: "2015-05-15",picture: 'http://i.imgur.com/uuuoqhW.jpg'  }
event_locations <<  { country: 'switzerland',name: "Casa dani", city: 'St-Imier', canton: 'Bern',cover: 'http://i.imgur.com/uuuoqhW.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '153',phone: '0795842654',website: 'www.google.ch' }

events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 2, event_location_id: 2, title: "Les amis du tricot", category: 'Decoration', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/RLe7blZ.jpg'  }
event_locations <<  { country: 'switzerland',name: "Chez carracio", city: 'St-Imier', canton: 'Neuchatel',cover: 'http://i.imgur.com/RLe7blZ.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }

events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 3, event_location_id: 3, title: "Halloween", category: 'Decoration', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/4G6VZ2I.jpg'  }
event_locations <<  { country: 'switzerland',name: "Fitzz", city: 'St-Imier', canton: 'Geneve',cover: 'http://i.imgur.com/4G6VZ2I.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }



events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 3, event_location_id: 4, title: "expositas", category: 'Convention', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/ZuprUOd.jpg'  }
event_locations <<  { country: 'switzerland',name: "Fitzz", city: 'St-Imier', canton: 'Vaud',cover: 'http://i.imgur.com/ZuprUOd.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }

events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 3, event_location_id: 5, title: "honore", category: 'Love', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/PNpGUvq.jpg'  }
event_locations <<  { country: 'switzerland',name: "Fitzz", city: 'St-Imier', canton: 'Valais',cover: 'http://i.imgur.com/PNpGUvq.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }

events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 3, event_location_id: 6, title: "rerum", category: 'Decoration', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/VIevFSY.jpg'  }
event_locations <<  { country: 'switzerland',name: "Fitzz", city: 'St-Imier', canton: 'Geneve',cover: 'http://i.imgur.com/VIevFSY.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }

events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 3, event_location_id: 7, title: "incrementis", category: 'Decoration', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/eS5fqiX.jpg'  }
event_locations <<  { country: 'switzerland',name: "Fitzz", city: 'St-Imier', canton: 'Geneve',cover: 'http://i.imgur.com/eS5fqiX.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }

events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 3, event_location_id: 8, title: "summo", category: 'Exposition', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/3C0wro8.jpg'  }
event_locations <<  { country: 'switzerland',name: "Fitzz", city: 'St-Imier', canton: 'Geneve',cover: 'http://i.imgur.com/3C0wro8.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }

events <<  { description:"Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia,tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordiconsilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.",user_id: 3, event_location_id: 9, title: "primum", category: 'Decoration', start_time: "2015-03-26", end_time: "2015-03-29",picture: 'http://i.imgur.com/tSCYp.jpg'  }
event_locations <<  { country: 'switzerland',name: "Fitzz", city: 'St-Imier', canton: 'Geneve',cover: 'http://i.imgur.com/tSCYp.jpg', category: 'party hard',street: 'rue des paquerettes 5', zip: '1232',latitude: '123981249119',longitude: '2394760239649235',likes: '13',phone: '0795842654',website: 'www.google.ch' }

User.create(users)
EventLocation.create(event_locations)
Event.create(events)
