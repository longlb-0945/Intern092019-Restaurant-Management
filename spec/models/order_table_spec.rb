require "rails_helper"

RSpec.describe OrderTable, type: :model do
  let!(:order) {FactoryBot.create :order}
  let!(:table) {FactoryBot.create :table}

  subject {FactoryBot.build(:order_table, order_id: order.id, table_id: table.id)}

  describe "Databases" do
    it {expect(subject).to have_db_column(:order_id).of_type :integer}
    it {expect(subject).to have_db_column(:table_id).of_type :integer}
  end

  describe "Create" do
    it {expect(subject).to be_valid}
  end

  describe "Associations" do
    it {expect(subject).to belong_to :order}
    it {expect(subject).to belong_to :table}
  end

  describe "Validations" do
    it {expect(subject).to validate_presence_of(:order_id).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to validate_presence_of(:table_id).with_message(I18n.t("errors_blank"))}

    it "#table_to_occupied" do
      expect(subject).to receive(:table_to_occupied)
      subject.save
    end
  end
end
