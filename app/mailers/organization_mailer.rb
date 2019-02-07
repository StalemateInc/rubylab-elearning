class OrganizationMailer < ApplicationMailer
  def response_on_application(user, organization, message = 'ok')
    @user = user
    @organization = organization
    @message = message
    mail( to: @user.email,
     subject: "Response on request of creation
      organization: #{organization.name}") do |format|
      format.text
      format.html
    end
  end

  def invite_to_organization(email, organization)
    @email = email
    @organization = organization
    mail( to: email,
      subject: "You take part of the organization: #{organization.name}") do |format|
      format.text
      format.html
    end
  end
end
