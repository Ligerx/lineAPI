require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  should belong_to(:restaurant)
  should belong_to(:user)

  should validate_presence_of(:party_size)
  should validate_presence_of(:restaurant)
  should validate_presence_of(:user)

  test "default values" do
    reservation = Reservation.new
    reservation.user = users(:one)
    reservation.restaurant = restaurants(:one)
    reservation.party_size = 2

    reservation.save

    assert_not reservation.cancelled
    assert_in_delta reservation.time_reserved, DateTime.now, 1.second
  end
end
