describe ParseEmailsForImport do
  describe '.call' do
    context 'when interactor ParseEmailsFromFile call right context' do
      subject(:context) do
        ParseEmailsForImport.call(ValidateEmailsFromInput.call(
          email: ['alfred@gmail.com casa@gmail.com',
          'arriva@mail.com, guru@mail.ru', 'village@gmail.com', 'garage@mail.org',
          'FORK@gmail.su', 'food', 'hello@mail.ru', 'hello@mail.ru'],
          file: file_fixture('emails.csv'), organization_id: 1))
      end
     
      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'must be contain context.emails' do
        expect(context.emails).to be
      end

      it 'has new emails in context.emails' do
      	expect(context.emails).to include('creater@gmail.ru')
      end

       it 'context.emails must match array' do
        expect(context.emails).to match_array(['alfred@gmail.com',
        'arriva@mail.com', 'casa@gmail.com', 'fork@gmail.su', 'garage@mail.org',
        'guru@mail.ru', 'village@gmail.com', 'hello@mail.ru', 'creater@gmail.ru',
        'saha@gmail.com', 'rusik@gmail.com', 'ryla@gmail.com'])
      end
    end
  end

  context 'when interactor ParseEmailsFromFile call broken context' do
    subject(:context) do
      ParseEmailsForImport.call(email: 'fodfe',
                                file: [], organization_id: 'false', emails: 'ddd')
    end

    it 'fails' do
      expect(context).to be_a_failure
    end
  end
end