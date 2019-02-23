# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
	$(document).ready ->
    $('.import-users-select').select2
        theme: 'bootstrap'
        width: '100%'
        tags: true
    return
return