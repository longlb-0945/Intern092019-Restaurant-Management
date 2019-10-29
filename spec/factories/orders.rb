FactoryBot.define do
  factory :order do
    name {FFaker::Address.city}
    phone {FFaker::PhoneNumber.phone_number}
    address {FFaker::AddressBR.full_address}
    status {Settings.factories.orders.status_faker}
    person_number {Settings.factories.orders.person_number_faker}
    total_amount {Settings.factories.orders.total_amount_faker}
  end
end
