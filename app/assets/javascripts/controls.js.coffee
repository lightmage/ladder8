$ ->
  $('a[href=#top]').click (event) -> 
    event.preventDefault()
    $('html, body').animate({scrollTop: 0}, 'slow')

  $('#chat-toggle').click (event) ->
    event.preventDefault()
    $('#chat').slideToggle()

  $('#comments-toggle').click (event) ->
    event.preventDefault()
    $('#comments').slideToggle()

  $('.form-reset').click (event) ->
    event.preventDefault()
    $('.search-query').val('')
