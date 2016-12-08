class Restaurant < ApplicationRecord
  has_many :reservations, :dependent => :destroy
end
