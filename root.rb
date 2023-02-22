require_relative 'app/lib/data_collection'

users = DataCollection::Parser.new
users.log_in

users.data_collection

DataCollection::Storage.new(users.data).data_record
