require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  should belong_to(:restaurant)
  should belong_to(:user)

  should validate_presence_of(:party_size)
  should validate_presence_of(:restaurant)
  should validate_presence_of(:user)

  
end
