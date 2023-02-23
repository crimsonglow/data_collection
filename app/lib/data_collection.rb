require_relative 'parser'
require_relative 'storage'
require_relative '../../setup_capybara'

require 'json'
require 'pry'

module DataCollection
  class LogInError < StandardError; end
  class IncorrectLogInInformation < StandardError; end
end
