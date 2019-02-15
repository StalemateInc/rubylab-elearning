class SendInvintation
  include Interactor

  #Redirect to worker job for create users, their membership and send emails to invite

  def call
    begin
      InvitePeopleFromEmailWorker.perform_async(context.emails,
       context.organization_id.to_i)
    rescue => e
      context.fail!(message: e)
    end
  end
end