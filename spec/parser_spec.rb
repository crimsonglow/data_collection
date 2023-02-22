require 'spec_helper'

RSpec.describe DataCollection::Parser do
  subject(:current_subject) { described_class.new }

  let(:user) { { 'email' => 'crimsonglow@i.ua', 'password' => 'e-bG7aYKV,WXebR' } }

  describe 'log_in' do
    before { ENV.merge!(user) }

    context 'when the data is wrong' do
      let(:user) { { 'email' => 'Error@i.ua', 'password' => 'e-bG7aYKV,WXebR' } }

      it { expect { current_subject.log_in }.to raise_error(DataCollection::IncorrectLogInInformation) }
    end

    context 'when for some reason, it failed to log in' do
      let(:user) { { 'email' => 'Error', 'password' => ' ' } }

      it { expect { current_subject.log_in }.to raise_error(DataCollection::LogInError) }
    end

    context 'when success' do
      before { current_subject.log_in }

      it do
        expect(page).to have_content('Top Questions')
        expect(page).to have_no_link('Log in')
      end
    end
  end

  context 'when collecting usernames from questions' do
    before { current_subject.data_collection }

    let(:questions) { find('#questions') }
    let(:path) { ".//a[contains(@href, '/users/')]" }

    it { expect(current_subject.data.flatten.size).not_to be_between(1, 10) }

    it 'is recorded nickname' do
      one_user = questions.find(:xpath, path, text: /\w/, match: :first).text

      expect(current_subject.data.flatten).to include one_user
    end
  end
end
