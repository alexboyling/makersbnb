# frozen_string_literal: true

require './lib/property'
require './lib/database_connection'

#DatabaseConnection.setup('makersbnb_test')

def persisted_data(table:, id:)
  DatabaseConnection.query("SELECT * FROM #{table} WHERE id = $1;", [id])
end

RSpec.describe Property do
  describe '.create' do
    it 'creates a new property' do
      property = Property.create(name: 'irrelvent', description: 'nice home', location: 'address', price: 12.50)

      expect(property).to be_a Property
      expect(property.name).to eq 'irrelvent'
      expect(property.description).to eq 'nice home'
      expect(property.location).to eq 'address'
      expect(property.price).to eq '$12.50'
    end

    it 'creates a property that holds persistant data' do 
      property = Property.create(name: 'irrelvent', description: 'nice home', location: 'address', price: 12.50)
      persisted_data = persisted_data(table: 'properties', id: property.id )

      expect(property.id).to eq persisted_data.first['id']
    end 
  end
end
