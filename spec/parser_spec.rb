require 'spec_helper'

RSpec.describe DataCollection::Parser do
  subject(:current_subject) { described_class.new }

  let(:user) { { 'email' => 'crimsonglow@i.ua', 'password' => 'e-bG7aYKV,WXebR' } }

  describe 'log_in' do
    before { ENV.merge!(user) }

    context 'when the user incorrect information and gets the message "The email or password is incorrect"' do
      let(:user) { { 'email' => 'Error@i.ua', 'password' => 'e-bG7aYKV,WXebR' } }

      it 'returns an error "IncorrectLogInInformation"' do
        expect { current_subject.log_in }.to raise_error(DataCollection::IncorrectLogInInformation)
      end
    end

    context 'when the user could not log in' do
      let(:user) { { 'email' => 'Error', 'password' => ' ' } }

      it 'returns an error "LogInError"' do
        expect { current_subject.log_in }.to raise_error(DataCollection::LogInError)
      end
    end

    context 'when the user is successfully log in' do
      it 'are no errors' do
        expect { current_subject.log_in }.not_to raise_error
      end
    end
  end

  context 'when user nicknames from questions are written to an array "data"' do
    before { current_subject.data_collection }

    it 'contains more than 10 nicknames' do
      expect(current_subject.data.flatten.size).to be > 10
    end

    it 'are no empty elements' do
      expect(current_subject.data.flatten).not_to include ' '
    end

    it 'contains only strings' do
      expect(current_subject.data.flatten).to all(be_a(String))
    end
  end
end
