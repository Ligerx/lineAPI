require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  should belong_to(:restaurant)
  should belong_to(:user)

  should validate_presence_of(:party_size)
  should validate_presence_of(:restaurant)
  should validate_presence_of(:user)

  test "default values" do
    reservation = buildReservation
    reservation.save

    assert_not reservation.cancelled
    assert_in_delta reservation.time_reserved, DateTime.now, 1.second
  end

  test "not seated scope" do
    reservation = buildReservation
    reservation.save

    assert_equal Reservation.not_seated.count, 2
  end

  test "seated scope" do
    assert_equal Reservation.not_seated.count, 2
  end

  test "hasnt left scope" do
    assert_equal Reservation.hasnt_left.count, 2
  end


  # helper method
  def buildReservation
    reservation = Reservation.new
    reservation.user = users(:user3)
    reservation.restaurant = restaurants(:unionGrill)
    reservation.party_size = 2
    return reservation
  end
end
