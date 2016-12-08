require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name, password: @user.password, phone: @user.phone } }, as: :json
    end

    assert_response 201
  end

  test "should show user" do
    get user_url(@user), as: :json
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: @user.email, first_name: @user.first_name, last_name: @user.last_name, password: @user.password, phone: @user.phone } }, as: :json
    assert_response 200
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json
    end

    assert_response 204
  end

  test "should make reservation" do
    user4 = users(:user4)
    porch = restaurants(:porch)
    post make_reservation_url(user4, porch), params: { reservation: { party_size: 5 } }, as: :json

    assert_response 200
    assert_equal porch.reservations.count, 4
  end

  test "should not make reservation" do
    user3 = users(:user3)
    porch = restaurants(:porch)
    post make_reservation_url(user3, porch), params: { reservation: { party_size: 5 } }, as: :json

    assert_response 422
    assert_equal porch.reservations.count, 3
  end

  test "should cancel reservation" do
    user3 = users(:user3)
    post cancel_reservation_url(user3), as: :json

    assert_response 204
    assert_equal user3.reservations.waiting_or_seated.count, 0
  end

  test "should not cancel reservations" do
    user4 = users(:user4)
    assert_equal user4.reservations.count, 0
    post cancel_reservation_url(user4), as: :json

    assert_response 422
  end

  test "general time with an open table" do
    user4 = users(:user4)
    unionGrill = restaurants(:unionGrill)

    get user_restaurant_url(user4, unionGrill), as: :json
    json = JSON.parse(response.body)

    assert_in_delta DateTime.now, DateTime.parse(json['restaurant']['general_estimated_seating_time']), 1.second
  end

  test "general time with no open tables and short line" do
    userOne = users(:one)
    unionGrill = restaurants(:unionGrill)
    # Make a reservation first
    post make_reservation_url(userOne, unionGrill), params: { reservation: { party_size: 5 } }, as: :json

    get user_restaurant_url(userOne, unionGrill), as: :json
    json = JSON.parse(response.body)

    # this date string is coming from the fixtures for the first seated person at Union Grill.
    # I just copied it over for this
    assert_in_delta DateTime.parse("2016-11-21 17:00:00") + 1.hour, DateTime.parse(json['restaurant']['general_estimated_seating_time']), 1.second
  end

  test "general time with long line" do
    # With 2 tables and 1 being seated in the fixture, I need to add 3 more people
    # in line to test the recursive capabilities of finding time
    unionGrill = restaurants(:unionGrill)
    user4 = users(:user4)
    userOne = users(:one)
    userTwo = users(:two)

    post make_reservation_url(user4, unionGrill), params: { reservation: { party_size: 5 } }, as: :json
    post make_reservation_url(userOne, unionGrill), params: { reservation: { party_size: 5 } }, as: :json
    post make_reservation_url(userTwo, unionGrill), params: { reservation: { party_size: 5 } }, as: :json

    get user_restaurant_url(userOne, unionGrill), as: :json
    json = JSON.parse(response.body)

    # this date string is coming from the fixtures for the first seated person at Union Grill.
    # I just copied it over for this
    assert_in_delta DateTime.parse("2016-11-21 17:00:00") + 2.hour, DateTime.parse(json['restaurant']['general_estimated_seating_time']), 1.second

  end

  test "personal time with an open table" do
    skip 'Skipping personal time tests because they share very similar code to the general time estimates.'
  end

  test "personal time with no open tables and short line" do
    skip
  end

  test "personal time with long line" do
    skip
  end

  test "position in line should be null if not in line" do
    unionGrill = restaurants(:unionGrill)
    user4 = users(:user4)

    get user_restaurant_url(user4, unionGrill), as: :json
    json = JSON.parse(response.body)

    assert_nil json['restaurant']['position_in_line']

  end

  test "position in line should work" do
    user3 = users(:user3)
    porch = restaurants(:porch)

    get user_restaurant_url(user3, porch), as: :json
    json = JSON.parse(response.body)

    assert_equal 1, json['restaurant']['position_in_line']
  end

  test "position in line should work 2" do
    user4 = users(:user4)
    porch = restaurants(:porch)
    # Make a reservation first
    post make_reservation_url(user4, porch), params: { reservation: { party_size: 5 } }, as: :json

    get user_restaurant_url(user4, porch), as: :json
    json = JSON.parse(response.body)

    assert_equal 2, json['restaurant']['position_in_line']
  end

end
