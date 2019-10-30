FactoryBot.define do
  factory :table do
    table_number {Settings.factories.tables.table_number_faker}
    max_size {Settings.factories.tables.max_size_faker}
    status {Settings.factories.tables.status_faker}
  end
end
