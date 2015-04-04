# Handles the main logic of the application with listing events, providing and handling async calls for listing
# Listing can be extended with infinite scrolling
# The listing view is in 2 modes : search or filter ~> search lists all events, filter do some filtering to the current events
# All filter/search parameters are stored in cookies with jQuery.cookies

# Encoding for Javascript
encUrl = (url) -> 
  return encodeURIComponent(url)

encHtml = (html) ->
  return $('<div />').text(html).html()
  
# For infinite scrolling
page = 0


# app is in search mode if it can find all upcoming events
# when filtering by date, it isn't in search mode anymore
is_searching = true

# execute AJAX query for loading all events with current parameters 
load_event = () ->
  page = 0
  console.log "main"
  $.ajax({
    url: create_ajax_url(), 
    dataType: "json", 
    #success callback actions
    success: (data) =>     
      append_next(data,true)  # add events to view
  })
  
# AJAX query for profile events list
load_event_profil = () ->
  console.log "profile"
  page = 0
  $.ajax({
    url: create_ajax_url_profil(), 
    dataType: "json", 
    #success callback actions
    success: (data) =>     
      append_next(data,true)  # add events to view
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
    flex_error.fadeIn("slow")
  else
    flex_error.hide()

  #iterate on each search result
  data.forEach (e) ->

    #date parsing
    from =  e.start_time[8..9]  + " " + month[parseInt(e.start_time[5..6]) - 1] + " " +e.start_time[0..3]
    to =  e.end_time[8..9]  + " " + month[parseInt(e.end_time[5..6]) - 1] + " " + e.end_time[0..3]

    #creation of the flexbox who contains the event's info
    event = $('<li class="flex-item">
          <a href="' + base_url + 'events/' + e.id + '" class="link">
          <div class="img-event">
          <div class="wrapperB" style="background-image: url(\'' + encHtml(e.picture) + '\');"></div>
          </div>
          <div class="content-event">
          <p class="title-event">' + encHtml(e.title) + '</p>
          <p class="date-event">From ' + from + ' to ' + to + '</p>
          <p class="multiline-ellipsis">

          ' + encHtml(e.description) + '
          </p>
          </div>
          </a>
          </li>
          ')
    
    # events for profile with delete button for current user with csrf token from Rails
    if $('#event-profil-page').length > 0
      event = $('<li class="flex-item">
          <a href="' + base_url + 'events/' + e.id + '" class="link">
          <div class="img-event">
          <div class="wrapperB" style="background-image: url(\'' + encHtml(e.picture) + '\');"></div>
          </div>
          <div class="content-event">
          <p class="title-event">' + encHtml(e.title) + '</p>
          <p class="date-event">From ' + from + ' to ' + to + '</p>
          <p class="multiline-ellipsis">

          ' + encHtml(e.description) + '
          </p>
          </div>
          </a>' + ( if $('#user_id').val() == user_id then '
          <form action="' + base_url + 'events/' + e.id + '" class="button_to" method="post">
          <div>
          <input name="_method" type="hidden" value="delete" />
          <input class="btn delete-confirm" type="submit" value="Delete" />
          <input name="authenticity_token" type="hidden" value="' + csrf_token + '" />
          </div>
          </form>' else '') + '
          </li>
          ')

    #append it to the flex-container
    $('.flex-container-events').append(event)
    
    # confirmation deletion
    $('.delete-confirm').off('click')
    $('.delete-confirm').click ->
      return confirm("This deletion cannot be undone. Do you wish to continue?") == true

# create the AJAX URL for the current filters / search mode
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
  
  # save filters/parameters
  store_in_cookies(categories, cantons, date, title)
  
  # return URL with server and parameters
  url = "main/load/" + encUrl(categories) + "/" + encUrl(cantons) + "/" + encUrl(date) + "/" + encUrl(title) + "/" + encUrl(limit) + "/" + encUrl(offset)
  return base_url + url

# AJAX URL profile
create_ajax_url_profil = () ->
  limit = 5
  offset = 5 * page
  
  # return URL with server and parameters
  url = "profil/load/" + $('#user_id').val() + "/"  + encUrl(limit) + "/" + encUrl(offset)
  console.log(base_url + url)
  return base_url + url

# store filters and search data in cookies for later reuse
store_in_cookies = (categories, cantons, date, title) ->
  $.cookie('categories', categories, { path: '/' })
  $.cookie('cantons', cantons, { path: '/' })
  $.cookie('date', date, { path: '/' })
  $.cookie('title', title, { path: '/' })
  $.cookie('is_searching', if is_searching then "1" else "0")
  
# restore the page, with events, filters and search data from cookies ~> do an AJAX call to load the data
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

  # load events with restored parameters
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

# change the search mode of the app, reseting filter on new reset
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

# Handle scrolling with mouse : infinite-scrolling with loading of events with AJAX
scroll_handler = () ->
  if($(window).scrollTop() >= $(document).height() - $(window).height())
    page++
    $.ajax({
      url: create_ajax_url(), 
      dataType: "json", 
      success: (data) =>
        append_next(data,false)
      })

# Scrolling for profile page
scroll_handler_profil = () ->
  if($(window).scrollTop() >= $(document).height() - $(window).height())
    page++
    $.ajax({
      url: create_ajax_url_profil(), 
      dataType: "json", 
      success: (data) =>
        append_next(data,false)
      })    


# binding JS <-> UI (document onload)
$ ->

  # flash info on first login
  $("#flash-first-login").dialog({
    modal: true,
    width: 'auto',
    buttons: {
      Ok: () ->
        $(this).dialog("close")
  }})
  
  # date picker for date filter
  $("#datepicker").datepicker({ 
    minDate: new Date(),
    dateFormat: 'yy-mm-dd',
    onSelect: () -> 
      change_search_mode(false) 
      load_event()
    ,
    firstDay: 1
  })

  # checkboxes filter
  $('.chk_category, .chk_canton').change ->
    verify_checkboxes($(this))
    #change_search_mode(false)  # search mode doesn't change on filtering by checkbox
    load_event()

  # search button
  $("#button-event-title").click ->
    change_search_mode(true)
    load_event()
    return false
  
  # restore all parameters
  $("#button-event-refresh").click ->
    $("#input-event-title").val("")
    change_search_mode(true)
    load_event()
    return false
  
  # search input
  $("#input-event-title").keypress (e) ->
    if e.which == 13
      change_search_mode(true)
      load_event() 
  
  # close notifications automatically
  $('.notify').delay(3000).fadeOut('slow', () ->       
    $('.welcome').fadeIn("slow")
  )

  # remove scroll
  $(window).off('scroll', scroll_handler)
  $(window).off('scroll', scroll_handler_profil)
  
  #profil page
  if $('#event-profil-page').length > 0
    $(window).scroll(scroll_handler_profil)
    load_event_profil()

  # Main page only
  if $('#event-main-page').length > 0
    # add infinite scolling
    $(window).scroll(scroll_handler)
    # restore filters, parameters and events list
    load_from_cookies()
