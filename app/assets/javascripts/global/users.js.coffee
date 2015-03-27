# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



$ ->
  
  import_button = $("#import")
  fetching = $("#fetching")

  verify_import = () ->  
    url = base_url + "import/verify"
    $.ajax({url: url, dataType: "json", success: (data) => 
      console.log "result ajax"

      is_fetching = data

      if is_fetching
        setTimeout(verify_import, 2000)
      else
        import_button.removeAttr("disabled")
        fetching.hide()
    })

  import_button.click ->
    console.log("click")
    
    
    if navigator.geolocation
        navigator.geolocation.getCurrentPosition(
          (position) ->
            console.log("Latitude : " + position.coords.latitude + ", longitude : " + position.coords.longitude)
            fetching.show()
            $.ajax(url: "/import/data/" + position.coords.latitude + "/" + position.coords.longitude)
            setTimeout(verify_import, 10000)
            import_button.attr("disabled", "")
          , (error) ->
            alert("vieux ZGEG shaaaaaaaaaaaaaaaaaaaaaare !!!!!")
        )
    else 
        alert("Geolocation is not supported by this browser.")
    
    
    

  if fetching.is(':visible')
    import_button.attr("disabled", "")
    setTimeout(verify_import, 2000)
    