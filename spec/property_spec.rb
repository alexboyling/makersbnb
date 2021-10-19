# frozen_string_literal: true

require 'property'

RSpec.describe Property do
  describe '.create' do
    xit 'creates a new property' do
      property = described_class.create(name: 'irrelvent', description: 'nice home', location: 'address', price: 12.50)

      expect(property).to be Property
      expect(property.name).to eq 'irrelvent'
      expect(property.description).to eq 'nice home'
      expect(property.location).to eq 'address'
      expect(property.price).to eq 12.50
    end
  end
end
