# frozen_string_literal: true

require 'user'

describe User do
  let(:user) { User.create(name: 'Jane', email: 'test@example.com', password: 'password123') }

  describe '.create' do
    it 'creates a new user' do
      expect(user).to be_a User
      expect(user.name).to eq 'Jane'
      expect(user.email).to eq 'test@example.com'
    end

    it 'hashes the password using BCrypt' do
      expect(BCrypt::Password).to receive(:create).with('password123')
      User.create(name: 'Jane', email: 'test@example.com', password: 'password123')
    end
  end

  describe '.authenticate' do
    it 'returns a user given a correct username and password, if one exists' do
      jimmy = User.create(name: 'Jimmy', email: 'test@example.com', password: 'password123')
      authenticated_user = User.authenticate(email: 'test@example.com', password: 'password123')

      expect(authenticated_user.id).to eq jimmy.id
    end
  end

  it 'returns nil given an incorrect email address' do
    expect(User.authenticate(email: 'wrong_email', password: 'password123')).to be_nil
  end

  it 'returns nil given an incorrect password' do
    expect(User.authenticate(email: 'test@example.com', password: 'wrongpassword')).to be_nil
  end

  describe '.find' do
    it 'returns the user' do
      result = User.find(id: user.id)

      expect(result.id).to eq user.id
      expect(result.email).to eq user.email
    end

    it 'returns nil if there is no ID given' do
      expect(User.find(id: nil)).to eq nil
    end
  end
end
