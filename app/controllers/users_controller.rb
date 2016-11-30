class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users/:id/restaurants
  def restaurants
    @restaurants = Restaurant.all
  end

  # GET /users/:id/restaurants/:restaurant_id
  def restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :phone)
    end





    # Checking for the general seating time as if you were
    # about to put yourself at the end of the line.
    def general_estimated_seating_time(restaurant)
      # .count is index + 1, which works because we're looking
      # from the point of view of a reservation that hasn't been created yet
      next_spot_in_line = restaurant.reservations.waiting.count

      # puts '-------- general estimated seating time next_spot_in_line is '
      # puts next_spot_in_line

      estimated_seating_time(restaurant, next_spot_in_line)
    end
    helper_method :general_estimated_seating_time

    # Estimate your personal seating time for a restaurant.
    def personal_estimated_seating_time(restaurant)
      user_reservation = restaurant.reservations.for_user(params[:id]).waiting.by_time_reserved.first

      # puts "*** user_reservation is #{user_reservation.inspect}"

      return nil if user_reservation.nil?

      waiting_list = restaurant.reservations.waiting.by_time_reserved
      user_spot_in_line = find_spot_in_line(user_reservation, waiting_list)

      # puts '-------- personal estimated seating time user_spot_in_line is '
      # puts user_spot_in_line

      estimated_seating_time(restaurant, user_spot_in_line)
    end
    helper_method :personal_estimated_seating_time

    def estimated_seating_time(restaurant, spot_in_line)
      num_empty_tables = restaurant.num_tables - restaurant.reservations.still_eating.count
      seated_and_waiting_list = restaurant.reservations.waiting_or_seated.by_time_reserved.by_time_seated

      calculate_estimated_seating_time(spot_in_line, num_empty_tables, seated_and_waiting_list)
    end

    # Calculate estimated seating time based on the corresponding person in front of them.
    # This could be a seated table or someone waiting in line.
    # If it's someone waiting, calculate the time based on who THAT person is waiting for.
    def calculate_estimated_seating_time(spot_in_line, num_empty_tables, seated_and_waiting_list)
      # Table available immediately if you're in the front of the line and a table is open for you.

      # puts '-------- inside calculate estimated seating time ------------'
      # puts spot_in_line
      # puts num_empty_tables

      empty_table_available_for_user = spot_in_line < num_empty_tables
      return DateTime.now if empty_table_available_for_user

      corresponding_spot_in_line = spot_in_line - num_empty_tables
      corresponding_reservation = seated_and_waiting_list[corresponding_spot_in_line]

      if corresponding_reservation.is_seated?
        return corresponding_reservation.time_seated + 1.hour
      else
        # Look at who the person you're waiting for is waiting for [recursive]
        return calculate_estimated_seating_time(corresponding_spot_in_line, num_empty_tables, seating_and_waiting_list) + 1.hour
      end

    end

    def find_spot_in_line(reservation, waiting_list)
      # Return the index of the reservation in the waiting list
      waiting_list.find_index(reservation) # remember, counting starts at 0
    end
end
