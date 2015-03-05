# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

load_event = () ->
   
     $.ajax({url: "/main/load/1/2/3/4/5/6", dataType: "json", success: (data) => 
             console.log "result ajax"

             alert(data)   

      
    })

$ ->
    $('.chk_category').change ->
      load_event()
      
      

