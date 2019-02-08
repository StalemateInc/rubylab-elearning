# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
	$('#is_org_creator').change ->
	  selector = $('#course_owner')
	  div = $('.course_owner_div')	
	  if @checked    
	    div.removeClass('d-none')
	    selector.prop('disabled', false)
	  else
	    div.addClass('d-none')
	    selector.prop('disabled', true)
	  return	
  return