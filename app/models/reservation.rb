class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user

  before_create :set_time_reserved
  before_create :default_cancelled_false

  validates :party_size, :restaurant, :user, presence: true

  # scopes used ONLY for chaining to other scopes
  scope :seated, -> { where.not(time_seated: nil) }
  scope :not_seated, -> { where(time_seated: nil) }
  scope :hasnt_left, -> { where(time_left: nil) }
  scope :not_cancelled, -> { where.not(cancelled: true) }

  scope :still_eating, -> { seated.where(time_left: nil) }
  scope :waiting, -> { where.not(time_reserved: nil).not_seated.not_cancelled } # not sure if not including time_left matters
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :waiting_or_seated, -> { where.not(time_reserved: nil).hasnt_left.not_cancelled } # so time_seated may or may not be nil

  scope :by_time_reserved, -> { order(:time_reserved) }
  scope :by_time_seated, -> { order(:time_seated) }

  def is_seated?
    # Not sure if I need to check for other conditions other than time_seated
    time_seated != nil
  end

  def cancel
    self.cancelled = true
  end

  private
    def set_time_reserved
      self.time_reserved = DateTime.now
    end

    def default_cancelled_false
      self.cancelled = self.cancelled || false
    end


end
