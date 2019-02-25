require 'rails_helper'
RSpec.describe InvitePeopleFromEmailWorker, type: :worker do
  context 'run with valid params' do
    let(:emails) { ['arrival@mail.com', 'casa_blanco@gmail.com', 'forks@gmail.su'] }
    let(:organization) { Organization.create(name: 'Test worker', description: 'Test send mails') }

    it 'and create new user only given in attributes' do
      user = User.find_by(email: 'hello@mail.ru')
      user.delete if user
      InvitePeopleFromEmailWorker.new.perform(emails, organization.id)
      expect(User.find_by(email: 'hello@mail.ru')).to be_nil
    end

    it 'and create new user' do
      user = User.find_by(email: 'arrival@mail.com')
      user.delete if user
      InvitePeopleFromEmailWorker.new.perform(emails, organization.id)
      user = User.find_by(email: 'arrival@mail.com')
      expect(user).to be
    end

    it 'and create new user' do
      user = User.find_by(email: 'forks@gmail.su')
      user.delete if user
      InvitePeopleFromEmailWorker.new.perform(emails, organization.id)
      user = User.find_by(email: 'forks@gmail.su')
      mm = Membership.find_by(user_id: user.id)
      expect(mm).to be
    end
  end
  context 'run with invalid params' do
    let(:emails) { 'not array' }
    let(:organization_id) { 'wrong organization_id' }
    
    it 'and fail' do
      expect(InvitePeopleFromEmailWorker.new.perform(emails, organization_id)).not_to be
    end

    it 
  end
end
