# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# e permet désormais permet d'échapper un paramètre d'URL
e = encodeURIComponent

page = 0

# exécution requête AJAX
load_event = () ->
  console.log(create_ajax_url())
  page = 0
  $.ajax({
    url: create_ajax_url(), 
    dataType: "json", 
    #success callback actions
    success: (data) => 
      console.log "result ajax"
      console.log data 
    
      append_next(data,true)
      
  })
  
#function for add event dynamically
append_next = (data,clear) ->
  #remove all child of flex-container with flex-item class
  if clear 
    $('.flex-container > .flex-item').remove();

  month = ['January','February','March','April','May','June','July','August','September','October','November','December']

  #iterate on each search result
  data.forEach (e) ->

    #date parsing
    from =  e.start_time[8..9]  + " " + month[parseInt(e.start_time[5..6]) - 1] + " " +e.start_time[0..3]
    to =  e.end_time[8..9]  + " " + month[parseInt(e.end_time[5..6]) - 1] + " " + e.end_time[0..3]

    #creation of the flexbox who contains the event's info
    event = $('<li class="flex-item">
          <div class="img-event">
          <div class="wrapperB" style="background-image: url(\'' + e.picture + '\');"></div>
          </div>
          <div class="content-event">
          <p class="title-event"><a class="link link-title" href="/events/' + e.id + '">' + e.title + '</a></p>
          <p class="date-event">From ' + from + ' to ' + to + '</p>
          <p class="multiline-ellipsis">

          ' + e.description + '
          </p>
          <div class="more-event">
          <button class="btn" href="#"><a class="link link-btn" href="/events/' + e.id + '">More</a></button>
          </div>
          </div>
          </li>')

    #append it to the flex-container
    $('.flex-container').append(event)

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
  title = "*" if title == ""
  
  limit = 5
  offset = 5 * page
  
  url = "main/load/" + e(categories) + "/" + e(cantons) + "/" + e(date) + "/" + e(title) + "/" + e(limit) + "/" + e(offset)
  return base_url + url

# vérification des checkbox cantons et catégories
# l'option "all" est exclusive avec toute autre option
verify_checkboxes = (checkbox) ->
  css_class = '.' + checkbox.prop('class')
  is_all = checkbox.val() == "all"
  is_checked = checkbox.is(':checked')
  
  # on a changé l'option "all"
  # soit on l'a coché et cela décoche les autres options, soit on l'a décoché et on annule l'action
  if is_all
    if is_checked
      $(css_class).slice(1).each -> $(this).prop('checked', false)
    else
      checkbox.prop('checked', true)
  
  # on a changé une option particulière
  # soit on l'a coché et "all" se décoche; soit on l'a décoché et "all" doit être coché si toutes sont décochées
  else
    if is_checked
      $(css_class).first().prop('checked', false)
    else
      all_unchecked = true
      $(css_class).slice(1).each -> all_unchecked = false if $(this).is(':checked')
      if all_unchecked
        $(css_class).first().prop('checked', true)
    
  

# binding JS <-> UI (document onload)
$ ->

  $('.chk_category, .chk_canton').change ->
    verify_checkboxes($(this))
    load_event()
      
  $("#datepicker").datepicker({ 
    minDate: new Date(),
    dateFormat: 'yy-mm-dd',
    onSelect: load_event
  })
  
  $("#button-event-title").click ->
    load_event()
    
  $("#input-event-title").keypress (e) ->
    load_event() if e.which == 13
      
  $('.notify-close').click ->
    $(this).closest('.notify').hide();

    
#infinite scolling

$(window).scroll ->
    console.log "scroll"
    if($(window).scrollTop() == $(document).height() - $(window).height())
        console.log page++
        $.ajax({
        url: create_ajax_url(), 
        dataType: "json", 
        success: (data) =>
            if(data)
                #alert("SCROLL")
                
                append_next(data,false)
            else
                alert("No More Event !")
        })



