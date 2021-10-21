# frozen_string_literal: true

require_relative 'database_connection'

class Property
  attr_reader :name, :description, :location, :price, :id, :host_id, :dates_booked

  def self.create(name:, description:, location:, price:, host_id:)
    result = DatabaseConnection.query(
      'INSERT INTO properties (location, price_per_night,
      name, description, host_id) VALUES ($1, $2, $3, $4, $5) RETURNING id,
      location, price_per_night, name, description, host_id;',
      [location, price, name, description, host_id]
    )
    Property.new(
      id: result.first['id'],
      name: result.first['name'],
      location: result.first['location'],
      price: result.first['price_per_night'],
      description: result.first['description'],
      host_id: result.first['host_id']
    )
  end

  def self.all
    result = DatabaseConnection.query('SELECT * FROM properties')
    result.map do |properties|
      Property.new(
        name: properties['name'],
        location: properties['location'],
        id: properties['id'],
        price: properties['price_per_night'],
        description: properties['description'],
        host_id: result.first['host_id']
      )
    end
  end

  def self.update(id:, name:, description:, location:, price:)
    result = DatabaseConnection.query(
      "UPDATE properties SET name = $2,
      description = $3,
      location = $4,
      price_per_night = $5 WHERE id = $1 RETURNING id,
      name, description, location, price_per_night, host_id",
      [id, name, description, location, price]
    )
    Property.new(
      name: result.first['name'],
      location: result.first['location'],
      id: result.first['id'],
      price: result.first['price_per_night'],
      description: result.first['description'],
      host_id: result.first['host_id']
    )
  end

  def self.find(id:)
    result = DatabaseConnection.query('SELECT * FROM properties WHERE id = $1;', [id])
    Property.new(
      name: result.first['name'],
      location: result.first['location'],
      id: result.first['id'],
      price: result.first['price_per_night'],
      description: result.first['description'],
      host_id: result.first['host_id']
    )
  end

  def self.where(host_id:)
    result = DatabaseConnection.query('SELECT * FROM properties WHERE host_id = $1;', [host_id])
    result.map do |property|
      Property.new(
        name: property['name'],
        location: property['location'],
        id: property['id'],
        price: property['price_per_night'],
        description: property['description'],
        host_id: property['host_id']
      )
    end
  end

  def initialize(id:, name:, description:, location:, price:, host_id:)
    @id = id
    @name = name
    @description = description
    @location = location
    @price = price
    @host_id = host_id
    @dates_booked = [] # Created an empty array to store dates
  end

  def bookings(booking_class = Booking)
    booking_class.find_by_property(property_id: id)
  end

end

# Created a delete to delete a specific property. Will need to delete any related bookings also
# def self.delete(id:)
#   DatabaseConnection.query("DELETE FROM bookings WHERE property_id = $1", [id])
#   DatabaseConnection.query("DELETE FROM properties WHERE id = $1", [id])
# end
