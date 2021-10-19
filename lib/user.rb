require 'bcrypt'
require_relative './database_connection'

class User
  attr_reader :id, :name, :email
  
  def self.create(name:, email:, password:)
    encrypted_password = BCrypt::Password.create(password)

    result = DatabaseConnection.query(
      "INSERT INTO users (name, email, password) 
      VALUES($1, $2, $3) 
      RETURNING id, name, email;", 
      [name, email, encrypted_password]
    )
    User.new(
      id: result[0]['id'], 
      name: result[0]['name'], 
      email: result[0]['email']
    )
  end

  def self.find(id:)
    return nil unless id
    result = DatabaseConnection.query("SELECT * FROM users WHERE id = $1", [id])
    User.new(
      id: result[0]['id'],
      name: result[0]['name'],
      email: result[0]['email'])
  end

  def initialize(id:, name:, email:)
    @id = id
    @name = name
    @email = email
  end

  def self.authenticate(email:, password:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE email = $1", [email])
    return unless result.any?
    return unless BCrypt::Password.new(result[0]['password']) == password
    
    User.new(
      id: result[0]['id'],
      name: result[0]['name'],
      email: result[0]['email'])
  end
end
