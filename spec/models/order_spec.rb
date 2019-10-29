require "rails_helper"

RSpec.describe Order, type: :model do
  let!(:customer) {FactoryBot.create :user, role: 2}
  let!(:staff) {FactoryBot.create :user, role: 1}
  subject {FactoryBot.build :order}

  describe "Database" do
    it {expect(subject).to have_db_column(:customer_id).of_type :integer}
    it {expect(subject).to have_db_column(:staff_id).of_type :integer}
    it {expect(subject).to have_db_column(:name).of_type :string}
    it {expect(subject).to have_db_column(:phone).of_type :string}
    it {expect(subject).to have_db_column(:address).of_type :string}
    it {expect(subject).to have_db_column(:status).of_type :integer}
    it {expect(subject).to have_db_column(:person_number).of_type :integer}
    it {expect(subject).to have_db_column(:total_amount).of_type :integer}
  end


  describe "Create" do
    it {expect(subject).to be_valid}
  end

  describe "Associations" do
    before do
      subject.customer_id = customer.id
      subject.staff_id = staff.id
    end
    it {expect(subject.customer).to eq(customer)}
    it {expect(subject.staff).to eq(staff)}
  end

  describe "Validations" do
    it {expect(subject).to validate_numericality_of(:customer_id).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_numericality_of(:staff_id).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_presence_of(:name).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to validate_presence_of(:phone).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to validate_presence_of(:address).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to validate_numericality_of(:total_amount).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_numericality_of(:person_number).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to define_enum_for(:status).with(%i(pending accepted cancel paid))}
    it {expect(subject).to accept_nested_attributes_for(:order_tables)}

    context "Customer/Staff valid allow nil" do
      before {subject.customer_id = nil}
      it {expect(subject).to be_valid}
    end

    context "Customer/Staff invalid" do
      before {subject.customer_id = "a"}
      it {expect(subject).not_to be_valid}
    end

    context "Name invalid" do
      before {subject.name = ""}
      it {expect(subject).not_to be_valid}
    end

    context "Phone invalid" do
      before {subject.phone = ""}
      it {expect(subject).not_to be_valid}
    end

    context "Address invalid" do
      before {subject.address = ""}
      it {expect(subject).not_to be_valid}
    end

    context "Total amount invalid" do
      before {subject.total_amount = "a"}
      it {expect(subject).not_to be_valid}
    end

    context "Person number numericality invalid" do
      before {subject.person_number = "a"}
      it {expect(subject).not_to be_valid}
    end

    context "Person number greater than invalid" do
      before {subject.person_number = Settings.factories.orders.person_number_min_invalid}
      it {expect(subject).not_to be_valid}
    end
  end
end
