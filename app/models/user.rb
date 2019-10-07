class User < ApplicationRecord
  enum role: {admin: 0, staff: 1, guest: 2}
  enum status: {enable: 0, disable: 1}

  has_many :rates, dependent: :nullify
  has_one :picture, as: :target, dependent: :destroy
end
