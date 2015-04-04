# Users Javascript Control - Manages fetching states
# Handles GPS location querying to user
# Allows to launch importing on Rails App with AJAX
# Handles the AJAX query in loop to verify if the fetching is still occuring on Rails

$ ->
  
  import_button = $("#import")
  fetching = $(".underway")
  notice = $(".notice")
  welcome = $(".welcome")

  # verify if the import is still active with AJAX call
  verify_import = () ->  
    url = base_url + "import/verify"
    $.ajax({url: url, dataType: "json", success: (data) => 

      is_fetching = data

      if is_fetching
        setTimeout(verify_import, 2000)
      else
        import_button.removeAttr("disabled")
        import_button.html("Share more events")
        welcome.fadeOut('slow', () ->       
          notice.html("Fetching finished")
          notice.fadeIn().delay(3000).fadeOut('slow', () ->
             welcome.fadeIn()
          )
        )
        
        fetching.hide()
    })

  # Launch an import task from FB with AJAX, only if the user gives us his current location
  import_button.click ->    
    if navigator.geolocation
        import_button.attr("disabled", "")
        navigator.geolocation.getCurrentPosition(
          (position) ->
            url = base_url + "import/data/" + position.coords.latitude + "/" + position.coords.longitude + "/" + $("#drop-down").val()
            fetching.show()
            import_button.html("A fetching is already occuring")
            $.ajax(url: url)
            setTimeout(verify_import, 10000)     
          , (error) ->
            alert("You decided not to use your current location, therefore you cannot import events on Social Events. Maybe you should reconsider your decision?")
            import_button.removeAttr("disabled")
        )
    else 
        alert("Geolocation is not supported by your browser. You can't import events on Social Events. Try using Google Chrome or Firefox.")

  if fetching.is(':visible')
    import_button.attr("disabled", "")
    import_button.html("A fetching is already occuring")
    setTimeout(verify_import, 2000)
    