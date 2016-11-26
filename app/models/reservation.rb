class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user

  scope :not_seated, -> { where(time_seated: nil) }
  scope :seated, -> { where.not(time_seated: nil) }
  scope :still_eating, -> { seated.where(time_left: nil) }
  scope :cancelled, -> { where(cancelled: true) }
  scope :not_cancelled, -> { where.not(cancelled: true) }
  scope :waiting, -> { where.not(time_reserved: nil).not_seated.not_cancelled } # not sure if not including time_left matters
  scope :for_user, ->(user_id) { where(user_id: user_id) }

  def position_in_line
    # given a user_id?, find the position of that user in the waiting list line
  end
end
