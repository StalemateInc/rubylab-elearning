# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
	$('#is_org_creator').change ->
	  if @checked
	    document.getElementById('course_owner').classList.remove 'd-none', 'disabled'
	    document.getElementById('course_owner').disabled = false
	  else
	    document.getElementById('course_owner').classList.add 'd-none', 'disabled'
	    document.getElementById('course_owner').disabled = true
	  return	
  return