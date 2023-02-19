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
      raise AlreadyLogIn if already_log_in?

      click_on('Log in', wait: 1)
      page_load_items?(xpath: '//input[@id="email"]')

      find(:xpath, '//input[@id="email"]').set(email)
      find(:xpath, '//input[@id="password"]').set(password)
      click_button('Log in', wait: 1)
      raise IncorrectLogInInformation if email_password_incorrect?
    end

    def move_to_the_questions_page
      find(:xpath, ".//span[text()='Questions']").click
      click_link('Show 50 items per page') if has_link?('Show 50 items per page')
    end

    def data_collection
      date << usernames_selection
      return unless pages_left?

      move_to_the_next_page
      data_collection
    end

    private

    def page_load_items?(xpath: './/header/div/a', css: 'span', text: 'Stack Overflow', attempts: 2)
      until (has_xpath?(xpath) && has_css?(css) && has_text?(text)) || attempts < 1
        refresh && attempts - 1
      end
      raise FailedLoadPage if attempts <= 0
    end

    def email_password_incorrect?
      has_content?(Constants::Messages::LOG_IN_ERROR[:incorrect_input_date])
    end

    def already_log_in?
      has_no_link?('Log in') && has_xpath?('.//a[@title="Help Center and other resources"]')
    end

    def usernames_selection
      user_data_in_the_question = find_all(:xpath, './/time/preceding-sibling::div')
      usernames = user_data_in_the_question.map { |i| i.find(:xpath, ".//a[contains(@href, 'users')]").text }
      usernames.reject(&:empty?)
    end

    def pages_left?
      has_link?('Next')
    end

    def move_to_the_next_page
      click_on('Next', wait: 1)
    end
  end
end
