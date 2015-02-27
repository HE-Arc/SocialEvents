# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  
  import_button = $("#import")
  fetching = $("#fetching")

  verify_import = () ->  
    $.ajax({url: "/import/verify", dataType: "json", success: (data) => 
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
    import_button.attr("disabled", "")
    fetching.show()
    $.ajax(url: "/import/data")
    setTimeout(verify_import, 2000)

  if fetching.is(':visible')
    import_button.attr("disabled", "")
    setTimeout(verify_import, 2000)
    