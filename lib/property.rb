# frozen_string_literal: true
require_relative 'database_connection'

class Property
  attr_reader :name, :description, :location, :price, :id

  def self.create(name:, description:, location:, price: )
    result = DatabaseConnection.query("INSERT INTO properties (location, price_per_night, name, description) VALUES ($1, $2, $3, $4) RETURNING id, location, price_per_night, name, description;", [location, price, name, description])
    Property.new(id: result.first['id'], name: result.first['name'], location: result.first['location'], price: result.first['price_per_night'], description: description)
  end

  def initialize(id:, name:, description:, location:, price: )
    @id = id
    @name = name 
    @description = description
    @location = location 
    @price = price 
  end 
end
