# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Encoding for Javascript
encUrl = (url) -> 
  return encodeURIComponent(url)

encHtml = (html) ->
  return $('<div />').text(html).html()
  
page = 0

# app is in search mode if it can find all upcoming events
# when filtering by date, it isn't in search mode anymore
is_searching = true

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
    $('.flex-container-events > .flex-item').remove()
    

  month = ['January','February','March','April','May','June','July','August','September','October','November','December']

  # handle events errors
  flex_error = $('.flex-container-error > .flex-item')
  if data[0] == undefined
    flex_error.show()
  else
    flex_error.hide()

  #iterate on each search result
  data.forEach (e) ->

    #date parsing
    from =  e.start_time[8..9]  + " " + month[parseInt(e.start_time[5..6]) - 1] + " " +e.start_time[0..3]
    to =  e.end_time[8..9]  + " " + month[parseInt(e.end_time[5..6]) - 1] + " " + e.end_time[0..3]

    #creation of the flexbox who contains the event's info
    event = $('<li class="flex-item">
          <div class="img-event">
          <div class="wrapperB" style="background-image: url(\'' + encHtml(e.picture) + '\');"></div>
          </div>
          <div class="content-event">
          <p class="title-event"><a class="link link-title" href="' + base_url + 'events/' + e.id + '">' + encHtml(e.title) + '</a></p>
          <p class="date-event">From ' + from + ' to ' + to + '</p>
          <p class="multiline-ellipsis">

          ' + encHtml(e.description) + '
          </p>
          <a class="link link-btn" href="/events/' + e.id + '">
          <div class="more-event">
          <button class="btn" href="#">More</button>
          </div>
          </a>
          </div>
          </li>')

    #append it to the flex-container
    $('.flex-container-events').append(event)

# création de l'URL pour requête AJAX
create_ajax_url = () ->
  categories = []
  $('.chk_category:checked').each -> categories.push($(this).val())
  categories = categories.join(',')
  
  cantons = []
  $('.chk_canton:checked').each -> cantons.push($(this).val())
  cantons = cantons.join(',')
  
  date = if is_searching then "all" else $("#datepicker").val()
      
  title = $("#input-event-title").val()
  title = "*" if title == ""
  
  limit = 5
  offset = 5 * page
  
  store_in_cookies(categories, cantons, date, title)
  
  url = "main/load/" + encUrl(categories) + "/" + encUrl(cantons) + "/" + encUrl(date) + "/" + encUrl(title) + "/" + encUrl(limit) + "/" + encUrl(offset)
  return base_url + url

# store filters and search data in cookies for later reuse
store_in_cookies = (categories, cantons, date, title) ->
  $.cookie('categories', categories)
  $.cookie('cantons', cantons)
  $.cookie('date', date)
  $.cookie('title', title)
  $.cookie('is_searching', if is_searching then "1" else "0")
  
# restore the page, with events, filters and search data from cookies
load_from_cookies = () ->
  categories = ($.cookie('categories') || "all").split(',')
  cantons = ($.cookie('cantons') || "all").split(',')
  date = $.cookie('date') || new Date()    
  title = $.cookie('title') || ""
  is_searching = if $.cookie('is_searching') then $.cookie('is_searching') == "1" else true
    
  if typeof(date) is 'string'
    if date == "all"
      date = new Date()
    else    
      date = new Date(date)

  $("#input-event-title").val(title) if title != "*"
  $("#datepicker").datepicker('setDate', date)
  
  $('.chk_category').each ->
    $(this).prop('checked', $.inArray($(this).val(), categories) != -1)
    
  $('.chk_canton').each ->
    $(this).prop('checked', $.inArray($(this).val(), cantons) != -1)
    
  load_event()
  
  
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

# change the search mode of the app
change_search_mode = (is_on) ->
  is_searching = is_on
  
  if is_searching
    chk_all_canton = $('.chk_canton').first()
    chk_all_category = $('.chk_category').first()
    chk_all_canton.prop('checked', true)
    chk_all_category.prop('checked', true)
    verify_checkboxes(chk_all_canton)
    verify_checkboxes(chk_all_category)
    $("#datepicker").datepicker('setDate', new Date())
  

# binding JS <-> UI (document onload)
$ ->

  $("#datepicker").datepicker({ 
    minDate: new Date(),
    dateFormat: 'yy-mm-dd',
    onSelect: () -> 
      change_search_mode(false) 
      load_event()
    ,
    firstDay: 1
  })

  $('.chk_category, .chk_canton').change ->
    verify_checkboxes($(this))
    #change_search_mode(false)  # search mode doesn't change on filtering by checkbox
    load_event()

  
  $("#button-event-title").click ->
    change_search_mode(true)
    load_event()
    return false
  
  $("#button-event-refresh").click ->
    $("#input-event-title").val("")
    change_search_mode(true)
    load_event()
    return false
    
  $("#input-event-title").keypress (e) ->
    if e.which == 13
      change_search_mode(true)
      load_event() 
      
  $('.notify-close').click ->
    $(this).closest('.notify').hide()

    
  #infinite scolling
  if $('#event-main-page').length > 0
    $(window).scroll ->
        console.log "scroll"
        if($(window).scrollTop() >= $(document).height() - $(window).height())
          page++
          console.log page
          $.ajax({
            url: create_ajax_url(), 
            dataType: "json", 
            success: (data) =>
              append_next(data,false)
          })

    load_from_cookies()

