class OrganizationMailer < ApplicationMailer
  def response_on_application(user, organization, message = 'ok')
    @user = user
    @organization = organization
    @message = message
    mail( to: @user.email,
     subject: "Response on request of creation organization: #{organization.name}") do |format|
      format.text
      format.html
    end
  end

  def invite_to_organization(email, organization)
    @email = email
    @organization = organization
    mail( to: email,
      subject: "You've been invited to be a part of a  \"#{organization.name}\" organization") do |format|
      format.text
      format.html
    end
  end
end
