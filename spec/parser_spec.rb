require 'spec_helper'

RSpec.describe DataCollection::Parser do
  subject(:current_subject) { described_class.new }

  let(:user) { { 'email' => 'crimsonglow@i.ua', 'password' => 'e-bG7aYKV,WXebR' } }

  describe 'log_in' do
    before { ENV.merge!(user) }

    context 'when the data is wrong' do
      let(:user) { { 'email' => 'Error@i.ua', 'password' => 'e-bG7aYKV,WXebR' } }

      it do
        expect { current_subject.log_in }.to raise_error(DataCollection::IncorrectLogInInformation)
      end
    end

    context 'when already log in' do
      before { current_subject.log_in }

      it { expect { current_subject.log_in }.to raise_error(DataCollection::AlreadyLogIn) }
    end

    context 'when success' do
      it do
        expect(page).to have_content('Top Questions')
        expect(page).to have_no_link('Log in')
      end
    end
  end

  context 'when move to the questions page' do
    before { current_subject.move_to_the_questions_page }

    it { expect(page).to have_content('All Questions') }
  end

  context 'when collecting usernames from questions' do
    before { current_subject.data_collection }

    it do
      one_user = first(:xpath, ".//time/preceding-sibling::div/div/a[contains(@href, 'users')]").text

      expect(current_subject.date.flatten).to include one_user
      expect(current_subject.date.flatten.count).to be > 10
      expect(current_subject.date).to be_a Array
      expect(current_subject.date).not_to be_empty
    end
  end
end