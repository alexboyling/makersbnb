# frozen_string_literal: true

require 'property'
require 'database_helpers'

describe Property do
  let(:user) { User.create(name: 'Jane', email: 'test@example.com', password: 'password123') }
  let(:user2) { User.create(name: 'Jimmy', email: 'test2@example.com', password: 'password123') }

  describe '.create' do
    it 'creates a new property' do
      property = Property.create(
        name: 'irrelevant',
        description: 'nice home',
        location: 'address',
        price: 12.50,
        host_id: user.id
      )

      expect(property).to be_a Property
      expect(property.name).to eq 'irrelevant'
      expect(property.description).to eq 'nice home'
      expect(property.location).to eq 'address'
      expect(property.price).to eq '$12.50'
      expect(property.host_id).to eq user.id
    end

    it 'creates a property that holds persistant data' do
      property = Property.create(
        name: 'irrelevant',
        description: 'nice home',
        location: 'address',
        price: 12.50,
        host_id: user.id
      )
      persisted_data = persisted_data(table: 'properties', id: property.id)

      expect(property.id).to eq persisted_data.first['id']
      expect(property.host_id).to eq persisted_data.first['host_id']
    end
  end

  describe '.all' do
    it 'returns creates an array of properties using the data stored in the db' do
      property = Property.create(name: 'irrelevant', description: 'nice home', location: 'address', price: 12.50,
                                 host_id: user.id)
      property2 = Property.create(name: 'irrelevant 2', description: 'great home', location: 'carnaby street',
                                  price: 140.50, host_id: user2.id)
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
      property = Property.create(name: 'irrelevant', description: 'nice home', location: 'address', price: 12.50,
                                 host_id: user.id)
      updated_property = Property.update(id: property.id, name: 'important', description: 'nice home',
                                         location: 'address2', price: 140.50)
      expect(updated_property).to be_a Property
      expect(updated_property.id).to eq property.id
      expect(updated_property.price).to eq '$140.50'
    end
  end

  describe '.find' do
    it 'returns a requested property object' do
      property = Property.create(name: 'irrelevant', description: 'nice home', location: 'address', price: 12.50,
                                 host_id: user.id)
      result = Property.find(id: property.id)

      expect(result).to be_a Property
      expect(result.id).to eq property.id
      expect(result.name).to eq property.name
    end
  end

  describe '.where' do
    it 'returns an array of properties belonging to a specified user' do
      property = Property.create(name: 'irrelevant', description: 'nice home', location: 'address', price: 12.50,
                                 host_id: user.id)
      property3 = Property.create(name:'irrelevant 3', description: 'even nicer home', location: 'london bridge', price: 135,
                                  host_id: user.id)
      result = Property.where(host_id: user.id)

      expect(result).to be_a Array
      expect(result.first.host_id).to eq user.id
      expect(result.last.host_id).to eq user.id
    end
  end

  let(:booking_class) { double(:booking_class) }

  describe '#bookings' do
    it 'calls .find_by_property on the Booking class' do
      property = Property.create(
        name: 'irrelevant',
        description: 'nice home',
        location: 'address',
        price: 12.50,
        host_id: user.id)

      expect(booking_class).to receive(:find_by_property).with(property_id: property.id)
      property.bookings(booking_class)
    end
  end
end
