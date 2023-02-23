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
      find(:xpath, ".//span[text()='Questions']").click
      find(:xpath, ".//div[text()='Bountied']").click
      show_50_items_if_available

      pages_count.times do
        data << usernames_selection

        click_next_page_if_present
      end
    end

    private

    def email_password_incorrect?
      has_content?('The email or password is incorrect.')
    end

    def log_in_successful?
      has_xpath?('.//a[@title="Help Center and other resources"]')
    end

    def show_50_items_if_available
      show_more = 'Show 50 items per page'
      click_link(show_more) if has_link?(show_more)
    end

    def pages_count
      path = './/a[contains(@href, "/questions?tab=bounties&page=")]'
      find_all(:xpath, path, text: /\d/).last.text.to_i
    end

    def usernames_selection
      find_all(:xpath, ".//div[@id='questions']//a[contains(@href, '/users/')]", text: /\w/).map(&:text)
    end

    def click_next_page_if_present
      next_page_pointer = 'Next'
      click_link(next_page_pointer, wait: 1) if has_link?(next_page_pointer)
    end
  end
end
