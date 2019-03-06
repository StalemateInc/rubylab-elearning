class SendInvitation < BaseInteractor

  # context:
  # emails: Array, organization: Organization

  def call
    begin
      InvitePeopleFromEmailWorker.perform_async(context.emails, context.organization.id)
    rescue => e
      fail_with_message('Failed to initialize invitation sending process.')
      context.errors.push(e)
    end
  end

end