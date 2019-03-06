require 'rails_helper'

RSpec.describe OrganizationMailer, type: :mailer do
  describe 'invite_to_organization' do
  	let(:email) { 'forks@gmail.su' }
  	let(:organization) { Organization.create(name: 'Test mailer',
  	  description: 'Test send mails')}
    let(:invite) { OrganizationMailer.invite_to_organization(email, organization) }

    it 'renders the headers' do
      expect(invite.subject).to eq('You take part of the organization: Test mailer')
      expect(invite.to).to eq(['forks@gmail.su'])
      expect(invite.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(invite.body.encoded).to match('Hello forks@gmail.su!')
    end
  end
end
