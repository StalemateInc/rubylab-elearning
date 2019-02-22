class InvitePeopleFromEmailWorker
  include Sidekiq::Worker

  def perform(emails, organization_id)
    organization = Organization.find(organization_id)
    emails.each do |email|
      user = User.find_or_create_by(email: email)
      Membership.find_or_create_by(user: user, organization: organization)
      OrganizationMailer.invite_to_organization(email, organization).deliver_later
    end
  end
end
