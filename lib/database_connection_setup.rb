# frozen_string_literal: true

require_relative 'database_connection'

if ENV['ENVIRONMENT'] == 'test'
  DatabaseConnection.setup('makersbnb_test')
else
  DatabaseConnection.setup('makerbnb')
end
