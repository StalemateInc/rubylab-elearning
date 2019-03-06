$(document).on 'click', '.cancel-decline-button', (e) ->
  e.preventDefault()
  id = $(this).data('id')
  decline_button = $("#join-request-#{id} .decline-request-button")
  decline_button.removeClass('d-none')
  $(this).closest('.comment-form').remove()