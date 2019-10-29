FactoryBot.define do
  factory :product do
    name {FFaker::Food.fruit}
    short_description {FFaker::Food.ingredient}
    price {Settings.factories.products.price_faker}
    status {Settings.factories.products.status_faker}
    stock {Settings.factories.products.stock_faker}
    total_rate {Settings.factories.products.total_rate_faker}
    after(:build) do |product|
      product.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: "default.png", content_type: 'image/jpeg')
    end
    association :category
  end
end
