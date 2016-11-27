class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def restaurants
    @restaurants = Restaurant.all
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

    # # Estimated time for someone to be seated if they make a reservation right now
    # # FIXME: I don't think this is the right way to calculate general waiting time...
    # #        I think it should be, look at the last person in line.
    # #        Or, if there's 3 people in line,
    # #        maybe pretend you're the 4th and calculate based on that!
    # def general_estimated_seating_time(restaurant)
    #   num_tables = restaurant.num_tables
    #   people_seated = restaurant.reservations.still_eating
    #   has_open_tables? = people_seated.count < num_tables
    #   first_to_leave = people_seated.first

    #   if has_open_tables?
    #     # FIXME: This isn't necessarily right?
    #     #        If a spot opens up, it might be for someone else.
    #     #        So if there's an open spot, that open spot always goes to the first person in line.
    #     DateTime.now
    #   elsif first_to_leave
    #     # Estimate that tables take one hour to leave
    #     first_to_leave.time_seated + 1.hour
    #   else
    #     # TODO: don't remember what this else case is for
    #     DateTime.now
    #   end
    # end
    # helper_method :general_estimated_seating_time

    # def personal_estimated_seating_time(restaurant)
    #   user_reservation = restaurant.reservations.for_user(params[:id]).by_time_reserved.first
    #   waiting_list = restaurant.reservations.waiting.by_time_reserved
    #   seating_and_waiting_list = restaurant.reservations.waiting_or_seated.by_time_reserved.by_time_seated

    #   calculate_seating_time(user_reservation, waiting_list, seating_and_waiting_list)
    # end
    # helper_method :personal_estimated_seating_time

    # def calculate_seating_time(reservation, waiting_list, seating_and_waiting_list)
    #   # Take a list of waiting + seated, and given an index, calculate the waiting time
    #   # If the person you're basing your waiting time on is NOT seated, but in line,
    #   # then find that person's waiting time, and add 1 hour to that.
    #   # So in this case, it would be one level of recursion(?)

    #   # TODO: if no line (or you are first in line) and is an empty seat, then no wait time right?
    #   #         But if you have a reservation, then I guess there is a lien
    #   #         Perhaps this is only the case if I'm calculating for general AND personal times with this same method?
    #   # TODO: what happens when the spot you're waiting for is done and gets a time_left?
    #   #       Then they're not in the line anymore, but how is the person waiting for that spot notified?

    #   user_spot_in_line = find_spot_in_line(reservation, waiting_list)
    #   corresponding_reservation = seating_and_waiting_list[user_spot_in_line]

    #   if corresponding_reservation.is_seated?
    #     corresponding_reservation.time_seated + 1.hour
    #   else
    #     # Do the recursive waiting time calculation here
    #     calculate_seating_time(corresponding_reservation, waiting_list, seating_and_waiting_list) + 1.hour
    #   end
    # end

    # Checking for the general seating time as if you were
    # about to put yourself at the end of the line.
    def general_estimated_seating_time(restaurant)
      # .count is index + 1, which works because we're looking
      # from the point of view of a reservation that hasn't been created yet
      next_spot_in_line = restaurant.reservations.waiting.count
      estimated_seating_time(restaurant, next_spot_in_line)
    end
    helper_method :general_estimated_seating_time

    # Estimate your personal seating time for a restaurant.
    def personal_estimated_seating_time(restaurant)
      user_reservation = restaurant.reservations.for_user(params[:id]).by_time_reserved.first
      waiting_list = restaurant.reservations.waiting.by_time_reserved

      user_spot_in_line = find_spot_in_line(user_reservation, waiting_list)
      estimated_seating_time(restaurant, user_spot_in_line)
    end
    helper_method :personal_estimated_seating_time

    def estimated_seating_time(restaurant, spot_in_line)
      num_empty_tables = restaurant.num_tables - restaurant.still_eating.count
      seated_and_waiting_list = restaurant.reservations.waiting_or_seated.by_time_reserved.by_time_seated

      calculate_estimated_seating_time(spot_in_line, num_empty_tables, seated_and_waiting_list)
    end

    # Calculate estimated seating time based on the corresponding person in front of them.
    # This could be a seated table or someone waiting in line.
    # If it's someone waiting, calculate the time based on who THAT person is waiting for.
    def calculate_estimated_seating_time(spot_in_line, num_empty_tables, seated_and_waiting_list)
      # Table available immediately if you're in the front of the line and a table is open for you.
      empty_table_available_for_user? = spot_in_line < num_empty_tables
      return DateTime.now if empty_table_available_for_user?

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
      waiting_list.index(user_reservation) # remember, counting starts at 0
    end
end
