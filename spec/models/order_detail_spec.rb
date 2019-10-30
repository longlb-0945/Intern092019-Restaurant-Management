require "rails_helper"

RSpec.describe OrderDetail, type: :model do
  let!(:order) {FactoryBot.create :order}
  let!(:product) {FactoryBot.create :product}
  subject {FactoryBot.build(:order_detail, order_id: order.id, product_id: product.id)}

  describe "Database" do
    it {expect(subject).to have_db_column(:order_id).of_type :integer}
    it {expect(subject).to have_db_column(:product_id).of_type :integer}
    it {expect(subject).to have_db_column(:price).of_type :integer}
    it {expect(subject).to have_db_column(:quantily).of_type :integer}
    it {expect(subject).to have_db_column(:amount).of_type :integer}
  end

  describe "Create" do
    it {expect(subject).to be_valid}
  end

  describe "Associations" do
    it {should belong_to :order}
    it {should belong_to :product}
  end

  describe "Validations" do
    it {expect(subject).to validate_presence_of(:order_id).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to validate_numericality_of(:order_id).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_presence_of(:product_id).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to validate_numericality_of(:product_id).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_numericality_of(:price).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_numericality_of(:quantily).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_numericality_of(:amount).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to allow_value(nil).for(:price)}
    it {expect(subject).to allow_value(nil).for(:quantily)}
    it {expect(subject).to allow_value(nil).for(:amount)}
  end
end
