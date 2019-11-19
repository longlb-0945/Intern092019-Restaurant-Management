class Notification < ApplicationRecord
  enum status: {unread: 0, read: 1}

  belongs_to :user

  scope :order_by, ->(order_key, order_type){order("#{order_key} #{order_type}")}
end
