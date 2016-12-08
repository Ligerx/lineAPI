class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def web
    render 'pages/simple-web-interface'
  end

  # GET /users/:id/restaurants
  def restaurants
    # TODO: Update this so it is only returning in range restaurants.
    if params[:restaurants]
      @restaurants = Restaurant.where(beaconUUID: uuid_params['uuids'])
    else
      # fallback if no uuids are attempted to be passed???
      @restaurants = Restaurant.all
    end
  end

  # GET /users/:id/restaurants/:restaurant_id
  def restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  # POST /users/:id/restaurants/:restaurant_id/make-reservation
  def make_reservation
    set_user

    # Currently only allowing only 1 reservation per restaurant at a time
    if @user.reservations.waiting.count > 0
      render  status: :unprocessable_entity,
              json: { message: "Failed to make reservation. You many only have one reservation at a time." }.to_json
      return
    end

    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      # Respond w/ the estimated seating time so the view can update itself.
      render json: { personal_estimated_seating_time: personal_estimated_seating_time(@reservation.restaurant) }
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # POST /users/:id/restaurants/cancel-reservation
  def cancel_reservation
    set_user

    reservations = @user.reservations.waiting
    if reservations.count == 0
      render  status: :unprocessable_entity,
              json: { message: "Failed to cancel reservation because you currently have no reservations." }.to_json
      return
    elsif reservations.count > 1
      render  status: :unprocessable_entity,
              json: { message: "WEIRD, why do you have more than 1 reservation?" }.to_json
      return
    end

    reservation = reservations.first
    reservation.cancel

    if reservation.save
      # Return 204 with empty body
      head :no_content
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end


  #########  JBuilder helper methods  #########
  # Checking for the general seating time as if you were
  # about to put yourself at the end of the line.
  def general_estimated_seating_time(restaurant)
    # .count is index + 1, which works because we're looking
    # from the point of view of a reservation that hasn't been created yet
    next_spot_on_wl = restaurant.reservations.waiting.count

    # puts '-------- general estimated seating time next_spot_on_wl is '
    # puts next_spot_on_wl
    # byebug
    time = estimated_seating_time(restaurant, next_spot_on_wl)

    time.strftime('%Y/%m/%d %H:%M')
  end
  helper_method :general_estimated_seating_time

  # Estimate your personal seating time for a restaurant.
  def personal_estimated_seating_time(restaurant)
    user_reservation = restaurant.reservations.for_user(params[:id]).waiting.by_time_reserved.first

    # puts "*** user_reservation is #{user_reservation.inspect}"

    return nil if user_reservation.nil?

    waiting_list = restaurant.reservations.waiting.by_time_reserved
    user_spot_on_wl = find_spot_in_line(user_reservation, waiting_list)

    # puts '-------- personal estimated seating time user_spot_on_wl is '
    # puts user_spot_on_wl

    time = estimated_seating_time(restaurant, user_spot_on_wl)

    time.strftime('%Y/%m/%d %H:%M')
  end
  helper_method :personal_estimated_seating_time

  def position_in_line(restaurant)
    user_reservation = restaurant.reservations.for_user(params[:id]).waiting.by_time_reserved.first
    waiting_list = restaurant.reservations.waiting
    spot = find_spot_in_line(user_reservation, waiting_list) # index 0

    if spot
      spot + 1 # make it start counting at 1
    else
      nil
    end
  end
  helper_method :position_in_line




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :phone)
    end


    # White list params for reservation
    def reservation_params
      puts params.inspect

      return {
        user_id: params[:id],
        restaurant_id: params[:restaurant_id],
        party_size: params[:reservation][:party_size]
      }
    end

    def uuid_params
      # permit the uuids array through
      params.require(:restaurants).permit(uuids: [])
    end


    def estimated_seating_time(restaurant, spot_on_wl)
      num_empty_tables = restaurant.num_tables - restaurant.reservations.still_eating.count
      seated_and_waiting_list = restaurant.reservations.waiting_or_seated.by_time_reserved.by_time_seated

      waiting_list = restaurant.reservations.waiting.by_time_reserved

      calculate_estimated_seating_time(spot_on_wl, num_empty_tables, seated_and_waiting_list, waiting_list)
    end

    # Calculate estimated seating time based on the corresponding person in front of them.
    # This could be a seated table or someone waiting in line.
    # If it's someone waiting, calculate the time based on who THAT person is waiting for.
    def calculate_estimated_seating_time(spot_on_wl, num_empty_tables, seated_and_waiting_list, waiting_list)
      # Table available immediately if you're in the front of the line and a table is open for you.

      empty_table_available_for_user = spot_on_wl < num_empty_tables
      return DateTime.now if empty_table_available_for_user

      corresponding_reservation = seated_and_waiting_list[spot_on_wl - num_empty_tables]

      if corresponding_reservation.is_seated?
        return corresponding_reservation.time_seated + 1.hour
      else
        # Look at who the person you're waiting for is waiting for [recursive]
        corresponding_spot_in_wl = find_spot_in_line(corresponding_reservation, waiting_list)
        return calculate_estimated_seating_time(corresponding_spot_in_wl, num_empty_tables, seated_and_waiting_list, waiting_list) + 1.hour
      end

    end

    def find_spot_in_line(reservation, list)
      # Return the index of the reservation in the waiting list
      list.find_index(reservation) # remember, counting starts at 0
    end

end
