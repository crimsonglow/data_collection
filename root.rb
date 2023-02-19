require_relative 'app/lib/data_collection'

users = DataCollection::Parser.new
begin
  users.log_in
  users.move_to_the_questions_page
rescue DataCollection::LogInError, DataCollection::IncorrectLogInInformation => e
  puts e.message
end
users.data_collection

DataCollection::Storage.new(users.date).data_record
