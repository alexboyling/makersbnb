require 'pg'

def setup_test_database
  connection = DatabaseConnection.setup('makersbnb_test')
  connection.exec("TRUNCATE users, properties, bookings;")
end 