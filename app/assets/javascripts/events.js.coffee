$ ->
    if document.location.href.indexOf('events') > -1 && $('#map') != null
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
