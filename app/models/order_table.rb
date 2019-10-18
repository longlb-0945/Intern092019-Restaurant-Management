class OrderTable < ApplicationRecord
  belongs_to :order
  belongs_to :table

  after_create :table_to_occupied

  private
  def table_to_occupied
    table.occupied!
  end
end
