class CheckOrderTimeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @order = Order.find_by id: args[0]
    if @order&.pending?
      @order.update_attribute(:status, 2)
    end
    puts "Hello rails! #{args[0]}"
  end
end
