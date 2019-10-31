class OrderTable < ApplicationRecord
  belongs_to :order
  belongs_to :table

  after_create :table_to_occupied

  validates :order_id, presence: true
  validates :table_id, presence: true

  private
  def table_to_occupied
    table.occupied!
  end
end
