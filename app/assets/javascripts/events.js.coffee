$ ->
    # Do not use the id 'map' unless you want to load google map API
    if $('#map').length > 0
      handler = Gmaps.build('Google')
      handler.buildMap
        internal: 
          id: "map"
        , ->
          marker = handler.addMarker({
            lat: $('#lat').val()
            lng: $('#lon').val()
          })
          handler.map.centerOn(marker)
