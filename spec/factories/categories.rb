FactoryBot.define do
  factory :category do
    name {FFaker::Name.unique.name}
    after(:build) do |category|
      category.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: "default.png", content_type: 'image/jpeg')
    end
  end
end
