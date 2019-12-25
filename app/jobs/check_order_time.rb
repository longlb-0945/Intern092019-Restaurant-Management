class CheckOrderTime < ActiveJob::Base
  queue_as :default

  def perform(*args)
    @order = Order.find_by id: args[0]
    @order.cancel! if @order&.pending?
    puts "Hello rails!"
  end
end
