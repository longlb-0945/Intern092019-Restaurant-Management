class OrderTable < ApplicationRecord
  belongs_to :order
  belongs_to :table

  after_create :table_to_occupied

  validates :order_id, presence: true
  validates :table_id, presence: true

  accepts_nested_attributes_for :table, reject_if: :all_blank

  private
  def table_to_occupied
    table.occupied!
  end
end
