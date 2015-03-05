# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# e permet désormais permet d'échapper un paramètre d'URL
e = encodeURIComponent

# exécution requête AJAX
load_event = () ->
  $.ajax({
    url: create_ajax_url(), 
    dataType: "json", 
    success: (data) => 
      console.log "result ajax"
      console.log data 
      alert(data)
  })

# création de l'URL pour requête AJAX
create_ajax_url = () ->
  categories = []
  $('.chk_category:checked').each -> categories.push($(this).val())
  categories = categories.join(',')
  
  cantons = []
  $('.chk_canton:checked').each -> cantons.push($(this).val())
  cantons = cantons.join(',')
  
  date = $("#datepicker").val()
  
  title = $("#input-event-title").val()
  if title == ""
    title = "*" 
  
  limit = 0
  offset = 0
  
  return "/main/load/" + e(categories) + "/" + e(cantons) + "/" + e(date) + "/" + e(title) + "/" + e(limit) + "/" + e(offset)


# binding JS <-> UI (document onload)
$ ->
  # vérification des checkbox cantons et catégories, au moins "all" doit être coché
#   $.each(
#   ['.chk_category', '.chk_canton'], (index, checkboxes) ->
    
#     $(checkboxes).change ->
#       if $(this).val() == "all" and $(this).is(':checked')
#         checkboxes.each -> 
      
      
#       is_checked = true
#       $(checkboxes + ':checked').each -> is_checked = if $(this).val() != "all" then false else is_checked
#       $(checkboxes).first().attr('checked', is_checked)
#   )

  $('.chk_category, .chk_canton').change ->      
    load_event()
      
  $("#datepicker").datepicker({ 
    minDate: new Date(),
    dateFormat: 'yy-mm-dd',
    onSelect: load_event
  })
  
  $("#button-event-title").click ->
    load_event()
      

