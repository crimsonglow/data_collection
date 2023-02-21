module DataCollection
  class Parser
    attr_reader :email, :password, :date

    def initialize
      @email = ENV['email']
      @password = ENV['password']
      @date = []
    end

    def log_in
      visit('https://stackoverflow.com/')
      click_on('Log in', wait: 1)
      find(:xpath, '//input[@id="email"]').set(email)
      find(:xpath, '//input[@id="password"]').set(password)
      click_button('Log in', wait: 1)
      raise IncorrectLogInInformation if email_password_incorrect?
      raise LogInError unless log_in_successful?
    end

    def move_to_the_questions_page
      find(:xpath, ".//span[text()='Questions']").click
      click_link('Show 50 items per page') if has_link?('Show 50 items per page')
    end

    def data_collection
      number_pages ||= find_all(:xpath, './/a[contains(@href, "/questions?tab=bounties&page=")]', text: /\d/).last.text.to_i
       while number_pages > 1
        date << usernames_selection
        move_to_the_next_page
        number_pages -= 1
      end

      while pages_left? && date.last !=  usernames_selection
        date << usernames_selection
        move_to_the_next_page
      end

      while date.last !=  usernames_selection
        date << usernames_selection
        return unless pages_left?

        move_to_the_next_page
      end

      # date << usernames_selection
      # return unless pages_left?

      # move_to_the_next_page
      # data_collection
    end

    private

    def email_password_incorrect?
      has_content?(Constants::Messages::LOG_IN_ERROR[:incorrect_input_date])
    end

    def log_in_successful?
      has_no_link?('Log in') && has_xpath?('.//a[@title="Help Center and other resources"]')
    end

    def usernames_selection
      find("#questions").find_all(:xpath, ".//a[contains(@href, '/users/')]", text: /\w/).map(&:text)

      # all_questions_on_page = find_all(:xpath, ".//div[contains(@id, 'question-summary')]")
      # usernames = all_questions_on_page.map { |i| i.find(:xpath, ".//a[contains(@href, '/users/')]", text: /\w/).text }
    end

    def pages_left?
      has_link?('Next')
    end

    def move_to_the_next_page
      click_on('Next', wait: 1)
    end
  end
end
