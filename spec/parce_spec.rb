require 'spec_helper'

RSpec.describe DataCollection::Parser do
  subject(:current_subject) { described_class.new }

  let(:user) { { 'email' => 'crimsonglow@i.ua', 'password' => 'e-bG7aYKV,WXebR' } }

  context 'when a successful login' do
    before do
      ENV.merge!(user)
      current_subject.log_in
    end

    it { expect(page).to have_content('Top Questions') }
  end

  context 'when the data collection takes place' do
    before { current_subject.data_collection }

    it do
      one_user = first(:xpath, './/time/preceding-sibling::div/div/a').text

      expect(current_subject.date.flatten).to include one_user
      expect(current_subject.date).to be_a Array
      expect(current_subject.date).not_to be_empty
    end
  end
end
