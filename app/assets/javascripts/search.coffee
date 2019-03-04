fetchQuery = null
fetchResultsCallback = null
fetchResults = $.debounce(450, ->
  user = $('.typeahead').data('user')
  $.post '/search.json', { search: {query: fetchQuery, user_id: user, entity: ['course', 'organization'] }}, (data) ->
    console.log(data)
    data = rebuild_response(data)
    if fetchResultsCallback
      fetchResultsCallback data
    return
  return
)

shorten = (data, char_amount) ->
  return data if data.length <= char_amount
  data.substring(0, char_amount) + '...'

rebuild_response = (data) ->
  mapped = $.map(data, (item) ->
    {
      id: item.id,
      class: item["class"],
      name: item.name,
      description: item.description,
      duration: item.duration,
      status: item.status
    }
  )
  return mapped

$(document).on 'turbolinks:load', ->
  $('#difficulty_filter').multiselect()
  $('#visibility_filter').multiselect()
  $('#search-course-checkbox').on 'change', ->
    $('#course-filters').toggleClass 'd-none'
    $.each $('#course-filters').children('select'), (index, element) ->
      element.toggleAttribute 'disabled'
      return
    return
  return

$(document).on 'turbolinks:load', ->
  $('.typeahead').typeahead { minLength: 4 },
    display: 'name',
    limit: 10,
    source: (query, syncResults, asyncResults) ->
      fetchQuery = query
      fetchResultsCallback = asyncResults
      fetchResults()
      return
    templates:
      header: '<h5 class="text-center">Search suggestions<h5>',
      suggestion: (data) ->
        if data.class == 'organization'
          template = '<div><i class=\'fas fa-users mr-1\'></i><strong>' + data.name + '</strong><br/><em>' + shorten(data.description, 50) + '</em></div>'
        else
          template = '<div><i class=\'fas fa-book-open mr-1\'></i><strong>' + data.name + '</strong><br/><em>' + shorten(data.description, 50) + '</em></div>'
        return template
  $('.typeahead').on 'typeahead:selected', (evt, item) ->
    $(location).attr 'href', '/courses/' + item.id
    return
  return

$(document).on 'turbolinks:before-cache', ->
  $('.typeahead').typeahead('destroy')