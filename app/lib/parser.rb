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
    end

    def data_collection
      find(:xpath, ".//span[text()='Questions']").click
      click_link('Show 50 items per page') if has_link?('Show 50 items per page')
      data_selection
    end

    private

    def data_selection
      date << find_all(:xpath, './/time/preceding-sibling::div/div/a').map(&:text)
      has_link?('Next', wait: 1) ? (click_on('Next', wait: 1) && data_selection) : return
    end
  end
end
