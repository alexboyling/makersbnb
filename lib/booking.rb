# frozen_string_literal: true

class Booking
  def self.create(host_id:, guest_id:, property_id:, start_date:, end_date:, booking_status:)
    result = DatabaseConnection.query(
      "INSERT INTO bookings (host_id, guest_id, property_id, start_date, end_date, booking_status) 
      VALUES ($1, $2, $3, $4, $5, $6) 
      RETURNING id, host_id, guest_id, property_id, start_date, end_date, booking_status;",
      [host_id, guest_id, property_id, start_date, end_date, booking_status]
    )
    Booking.new(
      id: result.first['id'],
      host_id: result.first['host_id'],
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
      host_id: result.first['host_id'],
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
        host_id: booking['host_id'],
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
        host_id: booking['host_id'],
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
    DatabaseConnection.query(
      "UPDATE bookings SET booking_status = 'confirmed' WHERE id = $1
      RETURNING id, host_id, guest_id, property_id, start_date, end_date, booking_status;",
      [id]
    )
    deny_other_bookings(Booking.find(id: id))
  end

  def self.deny(id:)
    DatabaseConnection.query(
      "UPDATE bookings SET booking_status = 'denied' WHERE id = $1
      RETURNING id, host_id, guest_id, property_id, start_date, end_date, booking_status;",
      [id]
    )
  end

  def self.deny_other_bookings(confirmed_booking)
    # get all other pending bookings for that property
    result = DatabaseConnection.query(
      "SELECT * FROM bookings WHERE property_id = $1 AND booking_status = $2",
      [confirmed_booking.property_id, 'pending']
    )
    other_bookings = result.map do |booking|
      Booking.new(
        id: booking['id'],
        host_id: booking['host_id'],
        guest_id: booking['guest_id'],
        property_id: booking['property_id'],
        start_date: booking['start_date'],
        end_date: booking['end_date'],
        booking_status: booking['booking_status']
      )
    end
    p other_bookings
    other_bookings.each do |booking|
      if overlaps(confirmed_booking, booking)
        deny(id: booking.id)
      end
    end
  end

  def self.overlaps(booking1, booking2)
    p booking1.start_date, booking1.end_date, booking2.start_date, booking2.end_date
    DatabaseConnection.query(
      "SELECT (DATE $1, DATE $2) OVERLAPS (DATE $3, DATE $4)",
    [booking1.start_date, booking1.end_date, booking2.start_date, booking2.end_date]
    )
  end

  attr_reader :id, :host_id, :guest_id, :property_id, :start_date, :end_date, :booking_status

  def initialize(id:, host_id:, guest_id:, property_id:, start_date:, end_date:, booking_status:)
    @id = id
    @host_id = host_id
    @guest_id = guest_id
    @property_id = property_id
    @start_date = start_date
    @end_date = end_date
    @booking_status = booking_status
  end

  def property_name
    name = DatabaseConnection.query("SELECT name FROM properties WHERE id = $1", [property_id])
    name.first['name']
  end

  def requester
    name = DatabaseConnection.query("SELECT name FROM users WHERE id = $1", [guest_id])
    name.first['name']
  end

  def host
    name = DatabaseConnection.query("SELECT host_id FROM properties WHERE id = $1", [property_id])
    name.first['host_id']
  end

end
