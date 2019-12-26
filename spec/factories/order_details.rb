FactoryBot.define do
  factory :order_detail do
    price {rand(Settings.factories.order_details.random_price_faker)}
    quantily {rand(Settings.factories.order_details.random_quantily_faker)}
    amount {rand(Settings.factories.order_details.random_amount_faker)}
  end
end
