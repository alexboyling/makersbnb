# frozen_string_literal: true
# need to decide how booking_status is used

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

  def self.all
    DatabaseConnection.query("SELECT * FROM bookings")
  end

  def self.delete(id:)
    DatabaseConnection.query("DELETE FROM bookings WHERE id = $1", [id])
  end

  def self.update(id:, booking_status:)
    result = DatabaseConnection.query(
      "UPDATE bookings SET booking_status = $1 WHERE id = $2
      RETURNING id, guest_id, property_id, start_date, end_date, booking_status;",
      [booking_status, id]
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

  def self.confirm(id:)
    Booking.update(id: self.id, booking_status: 'confirmed')
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

    def confirm
      Booking.update(id: self.id, booking_status: 'confirmed')
    end

end