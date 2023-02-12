module DataCollection
  class Storage
    attr_reader :file_path, :date

    def initialize(date)
      @file_path = 'date.json'
      @date = date
    end

    def data_record
      File.open(file_path, 'w') { |f| f.write JSON.pretty_generate(date.flatten) }
    end
  end
end
