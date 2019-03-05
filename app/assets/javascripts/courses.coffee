# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
	$('#course_is_org_creator').change ->
	  orgSelector = $('#course_owner')
	  orgSelectorDiv = $('.course_owner_div')
	  visibilitySelector = $('#course_visibility')

	  if @checked    	
	    orgSelectorDiv.removeClass('d-none')
	    orgSelector.prop('disabled', false)

	    visibilitySelector.append '<option value="organization">organization</option>'
	  else
	    orgSelectorDiv.addClass('d-none')
	    orgSelector.prop('disabled', true)

	    $('#course_visibility option[value=\'organization\']').remove()
	  return	

	$('#course_visibility').change ->
	  allowedUsersSelector = $('#course_allowed_users_selector')
	  allowedUsersDiv = $('.course_allowed_users_selector_div')

	  if $('#course_visibility :selected').text() == 'individuals'
	  	allowedUsersSelector.prop('disabled', false)
	  	allowedUsersDiv.removeClass('d-none')
	  else
	  	allowedUsersSelector.prop('disabled', true)
	  	allowedUsersDiv.addClass('d-none')
	  return	

	$(document).ready ->
	  $('.js-example-basic-multiple').select2
	    theme: "bootstrap"
	    width: '100%'
	  return

	$('#favorites').change ->
		if @checked
			$.ajax
      url: '/course/sortable'
      type: 'GET'
      data: sort:
        sort_by: $('#sort_by_course').val()
        direction: $('#sort_direction_course').val()
        favorites: 'true'
        my_org: $('#myorg').is(":checked")
		else
			$.ajax
      url: '/course/sortable'
      type: 'GET'
      data: sort:
        sort_by: $('#sort_by_course').val()
        direction: $('#sort_direction_course').val()
        favorites: 'false'
        my_org: $('#myorg').is(":checked")
		return

	$('#myorg').change ->
		if @checked
			$.ajax
      url: '/course/sortable'
      type: 'GET'
      data: sort:
        sort_by: $('#sort_by_course').val()
        direction: $('#sort_direction_course').val()
        favorites: $('#favorites').is(":checked")
        my_org: 'true'
		else
			$.ajax
      url: '/course/sortable'
      type: 'GET'
      data: sort:
        sort_by: $('#sort_by_course').val()
        direction: $('#sort_direction_course').val()
        favorites: $('#favorites').is(":checked")
        my_org: 'false'
		return

	$('#sort_direction_course').change ->
		$.ajax
			url: '/course/sortable'
			type: 'GET'
			data: sort:
				sort_by: $('#sort_by_course').val()
				direction: @value
				favorites: $('#favorites').is(":checked")
				my_org: $('#myorg').is(":checked")
		return

	slider = new Slider('#rating')
	slider.on 'slide', (sliderValue) ->
		document.getElementById('rating-val').textContent = sliderValue
		return
	slider.on 'change', (sliderValue) ->
		document.getElementById('rating-val').textContent = sliderValue.newValue
		return

	$('#rating-submit').click ->
		$.ajax
      url: window.location.href + '/rate'
      type: 'PATCH'
      data: rating: $('#rating').val()
    return
  return