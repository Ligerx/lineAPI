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

  test "seated scope" do
    assert_equal Reservation.seated.count, 5
  end

  test "not seated scope" do
    reservation = buildReservation
    reservation.save

    assert_equal Reservation.not_seated.count, 2
  end

  test "hasnt left scope" do
    assert_equal Reservation.hasnt_left.count, 3
  end

  test "not cancelled scope" do
    reservation = buildReservation
    reservation.cancelled = true
    reservation.save

    assert_equal Reservation.not_cancelled.count, Reservation.all.count - 1
  end

  test "still eating scope" do
    assert_equal Reservation.still_eating.count, 2
  end

  test "waiting scope" do
    assert_equal Reservation.waiting.count, 1
  end

  test "for user scope" do
    alex = users(:alex)
    assert_equal Reservation.for_user(alex.id).count, 1

    user3 = users(:user3)
    assert_equal Reservation.for_user(user3.id).count, 2
  end

  test "waiting or seated scope" do
    assert_equal Reservation.waiting_or_seated.count, 3
  end

  test "is seated method" do
    assert reservations(:seated1).is_seated?
    assert reservations(:seated2).is_seated?
    assert reservations(:old1).is_seated?
    assert_not reservations(:inLine).is_seated?
  end

  test "cancel method" do
    inLine = reservations(:inLine)
    inLine.cancel
    inLine.save

    assert inLine.cancelled = true
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
