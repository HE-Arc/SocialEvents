# Handles logic for event details 
# Show GMaps API
# Add dialog box to show fullscreen event cover

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
    
    $("#dialog-cover-opener").click ->
      $("#dialog-cover").dialog({
        draggable: false,
        resizable: false,
        width: 'auto',
      })
