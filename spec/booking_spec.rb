require 'booking'
require 'database_helpers'

describe Booking do
  let(:user) { User.create(name: 'Jane', email: 'test@example.com', password: 'password123') }
  let(:user2) { User.create(name: 'Jim', email: 'test@example.com', password: 'password123') }
  let(:property) { Property.create(name: 'Property 1', description: 'nice home', location: 'address', price: 50.00, user_id: user.id) }
  let(:property2) { Property.create(name: 'Property 2', description: 'nice home', location: 'address', price: 100.00, user_id: user.id) }
  let(:booking) { Booking.create(guest_id: user.id, property_id: property.id, start_date: '2021-10-01', end_date: '2021-10-08', booking_status: 'pending') }

  describe '.create' do
    it 'creates a new booking' do
      expect(booking).to be_a Booking
      expect(booking.start_date).to eq '2021-10-01'
      expect(booking.end_date).to eq '2021-10-08'
      expect(booking.booking_status).to eq 'pending'
    end

    it 'creates a booking that holds persistant data' do
      persisted_data = persisted_data(table: 'bookings', id: booking.id )

      expect(booking.id).to eq persisted_data.first['id']
    end
  end

  describe '.find' do
    it 'returns the requested booking object' do
      result = Booking.find(id: booking.id)

      expect(result).to be_a Booking
      expect(result.id).to eq booking.id
      expect(result.booking_status).to eq booking.booking_status
    end
  end

  describe '.find_by_guest' do
    it 'returns bookings by guest id' do
      # create booking 1
      booking = Booking.create(
        guest_id: user.id,
        property_id: property.id,
        start_date: '2021-10-01',
        end_date: '2021-10-08',
        booking_status: 'pending'
      )
      # create booking 2
      extra_booking = Booking.create(
        guest_id: user.id,
        property_id: property2.id,
        start_date: '2021-10-09',
        end_date: '2021-10-16',
        booking_status: 'confirmed'
      )

      bookings = Booking.find_by_guest(guest_id: user.id)
      result = bookings.last

      expect(bookings.length).to eq 2
      expect(result).to be_a Booking
      expect(result.id).to eq extra_booking.id
      expect(result.booking_status).to eq extra_booking.booking_status
    end
  end

  describe '.find_by_property' do
    it 'returns bookings by property id' do
      # create booking 1
      booking = Booking.create(
        guest_id: user2.id,
        property_id: property.id,
        start_date: '2021-10-01',
        end_date: '2021-10-08',
        booking_status: 'pending'
      )
      # create booking 2
      extra_booking = Booking.create(
        guest_id: user2.id,
        property_id: property.id,
        start_date: '2021-10-09',
        end_date: '2021-10-16',
        booking_status: 'confirmed'
      )

      bookings = Booking.find_by_property(property_id: property.id)
      result = bookings.last

      expect(bookings.length).to eq 2
      expect(result).to be_a Booking
      expect(result.id).to eq extra_booking.id
      expect(result.booking_status).to eq extra_booking.booking_status
    end
  end

  describe '.delete' do
    it 'it deletes the given booking' do
      Booking.delete(id: booking.id)

      expect(Booking.all.ntuples).to eq 0
    end
  end

  describe '.confirm' do
    it 'updates the booking status to confirmed' do
      confirmed_booking = Booking.confirm(id: booking.id)

      expect(confirmed_booking).to be_a Booking
      expect(confirmed_booking.id).to eq booking.id
      expect(confirmed_booking.booking_status).to eq 'confirmed'
    end
  end

  describe '.deny' do
    it 'updates the booking status to denied' do
      denied_booking = Booking.deny(id: booking.id)

      expect(denied_booking).to be_a Booking
      expect(denied_booking.id).to eq booking.id
      expect(denied_booking.booking_status).to eq 'denied'
    end
  end

  describe '#property_name' do
    it 'gets a property name for a booking' do
      expect(booking.property_name).to eq property.name
    end
  end

  describe '#requester' do
    it 'gets the name of the booking requester' do
      expect(booking.requester).to eq user.name
    end
  end
end
