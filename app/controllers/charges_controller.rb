require 'gmail'

class ChargesController < ApplicationController

  def new 
  end

  #paiement strip en euro

  def create
    @aircraft = Aircraft.find(params[:aircraft_id])
    @departure_city = params[:departure_city]
    @arrival_city = params[:arrival_city]
    @number_of_passengers = params[:number_of_passengers]
    @date = params[:departure_date]
    @current_user_id = current_user.id
    @user_name = User.find(@current_user_id).last_name
    @user_email = User.find(@current_user_id).email
    @user_phone = User.find(@current_user_id).phone.sub(/^./, '33')
    @amount = @aircraft.trip_cost_with_commission(@departure_city, @arrival_city, @number_of_passengers).to_i * 100
    
    customer = Stripe::Customer.create(:email => params[:stripeEmail], :source  => params[:stripeToken])
    charge = Stripe::Charge.create(:customer    => customer.id, :amount      => @amount, :description => 'Rails Stripe customer', :currency    => 'eur')

    UserFlight.create(
      place_departure: @departure_city, 
      place_arrival: @arrival_city, 
      number_of_people: @number_of_passengers, 
      date_departure: @date,
      flight_price: (@amount / 100), 
      user_id: @current_user_id)
    
    send_mail(@user_email, @user_name, @departure_city, @arrival_city, @number_of_passengers)    

    redirect_to confirm_page_path, notice: "Paiement accepté"

  rescue Stripe::CardError => e
    flash.now[:error] = e.message
    redirect_to aircraft_path
  end

  def send_mail(adresse, nom, depart, destination, nombre_de_passager )
    gmail = Gmail.connect(ENV['ADRESSE'],ENV['MDP'])
    email = gmail.compose do
      to adresse
      subject "Reservation de Jet privé"
      body "Bonjour #{nom},

      Ceci est un mail récapitulatif de votre commande sur Stratton Jets.
      Notre equipe prend en charge votre vol en jet privé au depart de #{depart}, a destination de #{destination} pour #{nombre_de_passager} passager(s).

      John Smith, General Manager"
    end
    email.deliver!
  end

  # def confirm_page

  #   @current_user = User.find(current_user.id)
  #   @current_user_flights = @current_user.user_flights
  #   @last_current_user_flight = @current_user_flights.last
  #   @current_user_id = current_user.id
  #   @user_name_l = User.find(@current_user_id).last_name
  #   @user_name_f = User.find(@current_user_id).first_name
  #   @user_email = User.find(@current_user_id).email
  #   @user_phone = User.find(@current_user_id).phone.sub(/^./, '33') 

  # end

  def confirm_page

    @current_user = User.find(current_user.id)

    @current_user_flights = @current_user.user_flights
    @last_current_user_flight = @current_user_flights.last
    @user_name_l = @current_user.last_name
    @user_name_f = @current_user.first_name
    @user_email = @current_user.email
    @user_phone = @current_user.phone.sub(/^./, '33') 

  end
  


  

end




