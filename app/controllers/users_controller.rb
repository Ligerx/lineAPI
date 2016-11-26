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

    # Estimated time that the next person
    # FIXME: I don't think this is the right way to calculate general waiting time...
    def general_estimated_seating_time(restaurant)
      first_to_leave = restaurant.reservations.still_eating.first

      if first_to_leave
        # Estimate that tables take one hour to leave
        first_to_leave.time_seated + 1.hour
      else
        # Placeholder time
        # Will be in the past by the time it reaches the client
        DateTime.now
      end
    end
    helper_method :general_estimated_seating_time

    def personal_estimated_seating_time(restaurant)
      # user = User.find(params[:id])

      # First find my spot in line
      # Then find the table corresponding to my spot in line
      #   or the

      # spot_in_line = restaurant.reservations.

      user_reservation = restaurant.reservations.for_user(params[:id]).first
    end
    helper_method :personal_estimated_seating_time
end
