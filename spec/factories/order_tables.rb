FactoryBot.define do
  factory :order_table do
    association :order
    association :table
  end
end
