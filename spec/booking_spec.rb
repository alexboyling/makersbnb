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

  describe '.find_by_guest' do
    it 'returns bookings by guest id' do
      # create booking 1
      booking = Booking.create(
        guest_id: user.id,
        property_id: nil,
        start_date: '2021-10-01',
        end_date: '2021-10-08',
        booking_status: 'pending'
      )
      # create booking 2
      extra_booking = Booking.create(
        guest_id: user.id,
        property_id: nil,
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

  describe '.confirm' do
    xit 'updates the booking status to confirm' do
      expect(booking.confirm).to change { booking.booking_status}.from('pending').to('confirmed')
    end
  end
end
