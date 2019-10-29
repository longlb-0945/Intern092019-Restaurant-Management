require "rails_helper"

RSpec.describe Table, type: :model do
  let!(:order) {FactoryBot.create :order}
  let!(:table) {Table.create(table_number: Settings.factories.tables.table_number_unique, max_size:  Settings.factories.tables.max_size_faker)}
  let!(:order_table) {FactoryBot.create(:order_table, order_id: order.id, table_id: table.id)}
  subject {FactoryBot.create :table}

  describe "Database" do
    it {expect(subject).to have_db_column(:table_number).of_type :integer}
    it {expect(subject).to have_db_column(:max_size).of_type :integer}
    it {expect(subject).to have_db_column(:status).of_type :integer}
  end


  describe "Create" do
    it {expect(subject).to be_valid}
  end

  describe "Associations" do
    it {expect(table.orders).to include(order)}
    it {expect(table.order_tables).to include(order_table)}
  end

  describe "Validations" do
    it {expect(subject).to validate_numericality_of(:table_number).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_numericality_of(:max_size).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_presence_of(:table_number).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to validate_presence_of(:max_size).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to define_enum_for(:status).with(%i(available occupied disable))}

    context "Table number greater than invalid" do
      before {subject.table_number = Settings.table_number_greater_invalid}
      it {expect(subject).not_to be_valid}
    end

    context "Max size greater than invalid" do
      before {subject.max_size = Settings.max_size_greater_invalid}
      it {expect(subject).not_to be_valid}
    end

    context "Max size less than invalid" do
      before {subject.max_size = Settings.max_size_less_invalid}
      it {expect(subject).not_to be_valid}
    end
  end
end
