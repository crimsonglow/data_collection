require_relative 'parser'
require_relative 'storage'
require_relative '../../config/setup_capybara'
require_relative '../../config/constants/log_in'

require 'json'
require 'pry'

module DataCollection
  class AlreadyLogIn < StandardError
    include Constants::LogIn

    def initialize
      super(ALREADY_LOG_IN)
    end
  end

  class IncorrectLogInInformation < StandardError
    include Constants::LogIn

    def initialize
      super(INCORRECT_INPUT_DATE)
    end
  end
end
