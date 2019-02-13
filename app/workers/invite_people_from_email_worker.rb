class InvitePeopleFromEmailWorker
  include Sidekiq::Worker

  # Create user, membership and send emails to user

  def perform(emails, organization_id)
    emails.each do |email|
      user = User.find_by(email: email) ? User.find_by(email: email) : User.create(email: email)
      unless Membership.find_by(user_id: user.id, organization_id: organization_id)
        Membership.create(user_id: user.id, organization_id: organization_id)
      end
      organization = Organization.find_by(id: organization_id)
      OrganizationMailer.invite_to_organization(email, organization).deliver_later
    end
  end
end
