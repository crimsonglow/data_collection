require 'spec_helper'

RSpec.describe DataCollection::Storage do
  FILE_PATH = 'spec/fixtures/date.json'.freeze
  DATE = [
    'cyril',
    'Federico Dorato',
    'R.Haughton',
    'ooo'
  ].freeze

  subject(:current_subject) { described_class.new(DATE) }

  context 'when the data collection call' do
    before do
      allow(current_subject).to receive(:file_path).and_return(FILE_PATH)
      current_subject.data_record
    end

    after do
      File.delete(FILE_PATH) if File.exist?(FILE_PATH)
    end

    it 'creates a data file' do
      file = JSON.parse(File.read(FILE_PATH))

      expect(file).to eq(DATE)
      expect(file).to be_a Array
      expect(file).not_to be_empty
    end
  end
end
