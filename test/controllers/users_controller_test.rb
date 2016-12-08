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
end
