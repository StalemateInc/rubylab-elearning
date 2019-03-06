describe ValidateEmailsFromInput do
  describe '.call' do
    context 'when interactor ValidateEmailsFromInput call right context' do
      subject(:context) do
        ValidateEmailsFromInput.call(email: ['alfred@gmail.com casa@gmail.com',
          'arriva@mail.com, guru@mail.ru', 'village@gmail.com', 'garage@mail.org',
          'FORK@gmail.su', 'food', 'hello@mail.ru', 'hello@mail.ru'],
          file: './storage/emails.csv', organization_id: 1)
      end
     
      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'has in context.emails valid email' do
        expect(context.emails).to include('alfred@gmail.com')
      end

      it 'hasn\'t in context.emails invalid email' do
        expect(context.emails).not_to include('food')
      end

      it 'has in context.emails.length 6 emails' do
        expect(context.emails.length).to eq(8)
      end

      it 'has in context.emails only in downcase' do
        expect(context.emails).to include('fork@gmail.su')
      end

      it 'context.emails must not be empty' do
        expect(context.emails).not_to match_array([])
      end

      it 'context.emails must match array' do
        expect(context.emails).to match_array(['alfred@gmail.com',
        'arriva@mail.com', 'casa@gmail.com', 'fork@gmail.su', 'garage@mail.org',
        'guru@mail.ru', 'village@gmail.com', 'hello@mail.ru'])
      end

      it 'has only uniqueness emails' do 
        count = context.emails.select {|value| value == 'hello@mail.ru'}
        expect(count.length).to eq(1)
      end
    end
  end

  context 'when interactor ValidateEmailsFromInput call broken context' do
    subject(:context) do
      ValidateEmailsFromInput.call(email: 'fodfe',
        file: [], organization_id: 'false')
    end

    it 'fails' do
      expect(context).to be_a_failure
    end
  end
end