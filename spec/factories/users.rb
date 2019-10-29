FactoryBot.define do
  factory :user do
    name {FFaker::Name.name}
    email {FFaker::Internet.email}
    password_digest {Settings.default_password}
    after(:build) do |user|
      user.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default_user.png")), filename: "default.png", content_type: 'image/jpeg')
    end
  end
end
