describe SendInvintation do
  describe '.call' do
    context 'when interactor SendInvintation call right context' do
      subject(:context) do
        SendInvintation.call(ParseEmailsFromFile.call(ValidateEmailsFromInput.call(
          email: ['alfred@gmail.com casa@gmail.com',
          'arriva@mail.com, guru@mail.ru', 'village@gmail.com', 'garage@mail.org',
          'FORK@gmail.su', 'food', 'hello@mail.ru', 'hello@mail.ru'],
          file: file_fixture('emails.csv'), organization_id: '1')))
      end

      it "succeeds" do
        expect(context).to be_a_success
      end

      it 'has context.emails with 10 emails' do
        expect(context.emails.length).to eq(12)
      end

      it 'has no empty context.organization_id' do
        expect(context.organization_id).to be
      end

      it 'has email in context.emails' do
        expect(context.emails).to include('creater@gmail.ru')
      end

      it "enqueues a InvitePeopleFromEmailWorker worker" do
        ActiveJob::Base.queue_adapter = :test
        expect(InvitePeopleFromEmailWorker).to have_enqueued_sidekiq_job(context
        	.emails, context.organization_id.to_i)
      end
    end
  end
end
