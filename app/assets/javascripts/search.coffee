# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
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