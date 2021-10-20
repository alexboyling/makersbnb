require 'property'
require 'database_helpers'

 describe Property do

  describe '.create' do
    it 'creates a new property' do
      property = Property.create(name: 'irrelevant', description: 'nice home', location: 'address', price: 12.50)

      expect(property).to be_a Property
      expect(property.name).to eq 'irrelevant'
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

  describe '.all' do 
    it 'returns creates an array of properties using the data stored in the db' do 
      property = Property.create(name: 'irrelevant', description: 'nice home', location: 'address', price: 12.50)
      property2 = Property.create(name: 'irrelevant 2', description: 'great home', location: 'carnaby street', price: 140.50)
      property_list = Property.all 

      persisted_data = persisted_data(table: 'properties', id: property.id)

      expect(property_list.length).to eq 2 
      expect(property_list.first.name).to eq 'irrelevant'
      expect(property_list.first).to be_a Property
      expect(property_list).to be_a Array 
      expect(property_list.first.id).to eq persisted_data.first['id']
    end 
  end

    describe '.update' do
      it 'updates an existing property' do
        property = Property.create(name: 'irrelevant', description: 'nice home', location: 'address', price: 12.50)
        updated_property = Property.update(id: property.id, name: 'important', description: 'nice home', location: 'address2', price: 140.50)
        expect(updated_property).to be_a Property
        expect(updated_property.id).to eq property.id
        expect(updated_property.price).to eq '$140.50'
    end
  end 

  describe '.find' do 
    it 'returns a requested property object' do 
      property = Property.create(name: 'irrelevant', description: 'nice home', location: 'address', price: 12.50)
      result = Property.find(id: property.id)

      expect(result).to be_a Property
      expect(result.id).to eq property.id
      expect(result.name).to eq property.name
    end 
  end
end
