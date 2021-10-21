# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require './database_connection_setup'
require 'sinatra/flash'
require './lib/user'
require './lib/property'
require './lib/booking'

class Makersbnb < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @user = User.find(id: session[:user_id])
    @properties = Property.all_available
    erb :index
  end

  get '/property/new' do 
    @user = User.find(id: session[:user_id])
    @property = Property 
    erb :'property/new' 
  end

  post '/property/new' do 
    @user = User.find(id: session[:user_id])
    @new_property = Property.create(name: params[:name],
    description: params[:description],
    location: params[:location],
    price: params[:price],
    host_id: session[:user_id])
    redirect('/')
  end 

  get '/property/:id/request-to-book' do
    @user = User.find(id: session[:user_id])
    @property = Property.find(id: params[:id])
    erb :'property/request-to-book'
  end

  post '/property/:id' do
    property = Property.find(id: params[:id])
    Booking.create(
      host_id: property.host_id,
      guest_id: session[:user_id],
      property_id: params[:id],
      start_date: params['start_date'],
      end_date: params['end_date'],
      booking_status: 'pending'
    )
    redirect '/'
  end

  get '/sessions/login' do
    erb :'sessions/login'
  end

  get '/users/sign_up' do
    erb :'users/sign_up'
  end

  post '/users' do
    user = User.create(name: params['name'], email: params['email'], password: params['password'])
    session[:user_id] = user.id
    redirect '/'
  end

  post '/sessions' do
    user = User.authenticate(email: params['email'], password: params['password'])
    if user
      session[:user_id] = user.id
      redirect('/')
    else
      flash[:notice] = 'Please check your email or password.'
      redirect('/sessions/login')
    end
  end

  post '/sessions/destroy' do
    session.clear
    flash[:notice] = 'You have signed out.'
    redirect('/')
  end

  get '/requests' do
    @user = User.find(id: session[:user_id])
    @guest_requests = Booking.find_by_guest(guest_id: session[:user_id])
    @properties = Property.where(host_id: session[:user_id])
    erb :'requests/index'
  end

  get '/requests/:id' do
    @user = User.find(id: session[:user_id])
    @booking = Booking.find(id: params[:id])
    @other_bookings = Booking.find_by_property(property_id: @booking.property_id)
    erb :'requests/manage'
  end

  post '/requests/:id/confirm' do
    Booking.confirm(id: params[:id])
    redirect('/requests')
  end

  post '/requests/:id/deny' do
    Booking.deny(id: params[:id])
    redirect('/requests')
  end

end
