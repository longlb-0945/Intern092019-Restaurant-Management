module OrderDetailsHelper
  def load_product_select o_id
    p_id = OrderDetail.where(order_id: o_id).map(&:product_id)
    Product.where.not(id: p_id).map do |t|
      ["#{t.name} | Price - #{t.price} | Stock - #{t.stock}", t.id]
    end
  end
end
