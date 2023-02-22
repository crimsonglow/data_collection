module DataCollection
  class Parser
    attr_reader :email, :password, :data

    def initialize
      @email = ENV['email']
      @password = ENV['password']
      @data = []
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

    def data_collection
      move_to_the_questions_page
      filter_tab_by_bountied
      try_to_show_50_items

      pages_count.times do
        data << usernames_selection

        try_move_to_the_next_page
      end
    end

    private

    def email_password_incorrect?
      has_content?(Constants::Messages::LOG_IN_ERROR[:incorrect_input_date])
    end

    def log_in_successful?
      has_no_link?('Log in') && has_xpath?('.//a[@title="Help Center and other resources"]')
    end

    def move_to_the_questions_page
      find(:xpath, ".//span[text()='Questions']").click
    end

    def filter_tab_by_bountied
      find(:xpath, ".//div[text()='Bountied']").click
    end

    def try_to_show_50_items
      show_more = 'Show 50 items per page'
      click_link(show_more) if has_link?(show_more)
    end

    def pages_count
      path = './/a[contains(@href, "/questions?tab=bounties&page=")]'
      find_all(:xpath, path, text: /\d/).last.text.to_i
    end

    def usernames_selection
      find('#questions').find_all(:xpath, ".//a[contains(@href, '/users/')]", text: /\w/).map(&:text)
    end

    def try_move_to_the_next_page
      next_page_pointer = 'Next'
      click_link(next_page_pointer, wait: 1) if has_link?(next_page_pointer)
    end
  end
end
