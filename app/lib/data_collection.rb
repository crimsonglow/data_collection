require_relative 'parser'
require_relative 'storage'
require_relative '../../config/setup_capybara'
require_relative '../../config/constants/messages'

require 'json'
require 'pry'

module DataCollection
  class AlreadyLogIn < StandardError
    include Constants::Messages

    def initialize
      super(LOG_IN_ERROR[:already_log_in])
    end
  end

  class IncorrectLogInInformation < StandardError
    include Constants::Messages

    def initialize
      super(LOG_IN_ERROR[:incorrect_input_date])
    end
  end
end
