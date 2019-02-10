# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
	$('#course_is_org_creator').change ->

	  orgSelector = $('#course_owner')
	  orgSelectorDiv = $('.course_owner_div')
	  userVisibilitySelector = $('#course_visibility_user')
	  userVisibilityDiv = $('.course_visibility_user_div')
	  orgVisibilitySelector = $('#course_visibility_org')
	  orgVisibilityDiv = $('.course_visibility_org_div')

	  if @checked    	
	    orgSelectorDiv.removeClass('d-none')
	    orgSelector.prop('disabled', false)

	    userVisibilitySelector.prop('disabled', true)
	    orgVisibilitySelector.prop('disabled', false)
	    userVisibilityDiv.addClass('d-none')
	    orgVisibilityDiv.removeClass('d-none')
	  else
	    orgSelectorDiv.addClass('d-none')
	    orgSelector.prop('disabled', true)

	    userVisibilitySelector.prop('disabled', false)
	    orgVisibilitySelector.prop('disabled', true)
	    userVisibilityDiv.removeClass('d-none')
	    orgVisibilityDiv.addClass('d-none')
	  return	
  return