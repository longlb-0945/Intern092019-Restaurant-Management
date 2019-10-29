FactoryBot.define do
  factory :category do
    name {FFaker::Food.vegetable}
    after(:create) do |category|
      category.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: "default.png", content_type: 'image/jpeg')
    end
  end
end
