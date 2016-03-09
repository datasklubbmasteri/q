$('#quote-form').submit (event) ->
  data =
    name: $('.name-input-field').val()
    text: $('.text-input-field').val()
    context: $('.context-input-field').val()
  $.ajax
    type: 'POST'
    url: '/create'
    data: JSON.stringify data
    contentType: 'application/json'
    complete: (xhr, status) ->
      window.location = '/'
  event.preventDefault()
