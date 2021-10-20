require 'booking'
require 'database_helpers'

describe Booking do
  let(:user) { User.create(name: 'Jane', email: 'test@example.com', password: 'password123') }
  let(:booking) { Booking.create(guest_id: user.id, property_id: nil, start_date: '2021-10-01', end_date: '2021-10-08', booking_status: 'pending') }

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

  describe '.delete' do
    it 'it deletes the given booking' do
      Booking.delete(id: booking.id)

      expect(Booking.all.ntuples).to eq 0
    end
  end

  describe '.update' do
    it 'updates the booking status' do
      updated_booking = Booking.update(
        id: booking.id,
        booking_status: 'confirmed'
      )
      
      expect(updated_booking).to be_a Booking
      expect(updated_booking.id).to eq booking.id
      expect(updated_booking.booking_status).to eq 'confirmed'
    end
  end
end
