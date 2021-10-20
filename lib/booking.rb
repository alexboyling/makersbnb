# frozen_string_literal: true

class Booking
  def self.create(guest_id:, property_id:, start_date:, end_date:, booking_status:)
    result = DatabaseConnection.query(
      "INSERT INTO bookings (guest_id, property_id, start_date, end_date, booking_status) 
      VALUES ($1, $2, $3, $4, $5) 
      RETURNING id, guest_id, property_id, start_date, end_date, booking_status;",
      [guest_id, property_id, start_date, end_date, booking_status]
    )
    Booking.new(
      id: result.first['id'],
      guest_id: result.first['guest_id'],
      property_id: result.first['property_id'],
      start_date: result.first['start_date'],
      end_date: result.first['end_date'],
      booking_status: result.first['booking_status']
    )
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM bookings WHERE id = $1", [id])
    Booking.new(
      id: result.first['id'],
      guest_id: result.first['guest_id'],
      property_id: result.first['property_id'],
      start_date: result.first['start_date'],
      end_date: result.first['end_date'],
      booking_status: result.first['booking_status']
    )
  end
  
  def self.find_by_guest(guest_id:)
    result = DatabaseConnection.query("SELECT * FROM bookings WHERE guest_id = $1", [guest_id])
    result.map do |booking|
      Booking.new(
        id: booking['id'],
        guest_id: booking['guest_id'],
        property_id: booking['property_id'],
        start_date: booking['start_date'],
        end_date: booking['end_date'],
        booking_status: booking['booking_status']
      )
    end
  end

  def self.find_by_property(property_id:)
    result = DatabaseConnection.query("SELECT * FROM bookings WHERE property_id = $1", [property_id])
    result.map do |booking|
      Booking.new(
        id: booking['id'],
        guest_id: booking['guest_id'],
        property_id: booking['property_id'],
        start_date: booking['start_date'],
        end_date: booking['end_date'],
        booking_status: booking['booking_status']
      )
    end
  end

  def self.all
    DatabaseConnection.query("SELECT * FROM bookings")
  end

  def self.delete(id:)
    DatabaseConnection.query("DELETE FROM bookings WHERE id = $1", [id])
  end

  def self.confirm(id:)
    result = DatabaseConnection.query(
      "UPDATE bookings SET booking_status = 'confirmed' WHERE id = $1
      RETURNING id, guest_id, property_id, start_date, end_date, booking_status;",
      [id]
    )
    Booking.new(
      id: result.first['id'],
      guest_id: result.first['guest_id'],
      property_id: result.first['property_id'],
      start_date: result.first['start_date'],
      end_date: result.first['end_date'],
      booking_status: result.first['booking_status']
    )
  end

  def self.deny(id:)
    result = DatabaseConnection.query(
      "UPDATE bookings SET booking_status = 'denied' WHERE id = $1
      RETURNING id, guest_id, property_id, start_date, end_date, booking_status;",
      [id]
    )
    Booking.new(
      id: result.first['id'],
      guest_id: result.first['guest_id'],
      property_id: result.first['property_id'],
      start_date: result.first['start_date'],
      end_date: result.first['end_date'],
      booking_status: result.first['booking_status']
    )
  end

  attr_reader :id, :guest_id, :property_id, :start_date, :end_date, :booking_status

  def initialize(id:, guest_id:, property_id:, start_date:, end_date:, booking_status:)
    @id = id
    @guest_id = guest_id
    @property_id = property_id
    @start_date = start_date
    @end_date = end_date
    @booking_status = booking_status
  end

  def property_name
    name = DatabaseConnection.query("SELECT name FROM properties WHERE id = $1", [self.property_id])
    name.first['name']
  end

  def requester
    name = DatabaseConnection.query("SELECT name FROM users WHERE id = $1", [self.guest_id])
    name.first['name']
  end

end
