# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('#sort_direction_org').on 'change', ->
    $.ajax
      url: '/organization/sortable'
      type: 'GET'
      data: sort:
        sort_by: $('#sort_by_org').val()
        direction: @value
    return
  return