# Users Javascript Control - Manages fetching states
# Handles GPS location querying to user
# Allows to launch importing on Rails App with AJAX
# Handles the AJAX query in loop to verify if the fetching is still occuring on Rails

$ ->
  
  import_button = $("#import")
  fetching = $(".fetching")

  # verify if the import is still active with AJAX call
  verify_import = () ->  
    url = base_url + "import/verify"
    $.ajax({url: url, dataType: "json", success: (data) => 

      is_fetching = data

      if is_fetching
        setTimeout(verify_import, 2000)
      else
        import_button.removeAttr("disabled")
        fetching.hide()
    })

  # Launch an import task from FB with AJAX, only if the user gives us his current location
  import_button.click ->    
    
    if navigator.geolocation
        navigator.geolocation.getCurrentPosition(
          (position) ->
            url = base_url + "import/data/" + position.coords.latitude + "/" + position.coords.longitude
            console.log("Latitude : " + position.coords.latitude + ", longitude : " + position.coords.longitude)
            fetching.show()
            $.ajax(url: url)
            setTimeout(verify_import, 10000)
            import_button.attr("disabled", "")
          , (error) ->
            alert("You decided not to use your current location, therefore you cannot import events on Social Events. Maybe you should reconsider your decision?")
        )
    else 
        alert("Geolocation is not supported by your browser. You can't import events on Social Events. Try using Google Chrome or Firefox.")
    
    
    

  if fetching.is(':visible')
    import_button.attr("disabled", "")
    setTimeout(verify_import, 2000)
    