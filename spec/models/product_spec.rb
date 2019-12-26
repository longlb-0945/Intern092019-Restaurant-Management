require "rails_helper"

RSpec.describe Product, type: :model do
  let!(:category){FactoryBot.create :category}
  subject {FactoryBot.build :product, category_id: category.id}

  describe "Create" do
    it {expect(subject).to be_valid}
    it {expect(subject.image).to be_attached}
  end

  describe "Associations" do
    it {expect(subject).to belong_to :category}
  end

  describe "Validations" do
    it {expect(subject).to validate_presence_of(:name).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to validate_numericality_of(:category_id).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_presence_of(:price).with_message(I18n.t("errors_blank"))}
    it {expect(subject).to validate_numericality_of(:price).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to validate_numericality_of(:stock).with_message(I18n.t("errors_not_a_number"))}
    it {expect(subject).to define_enum_for(:status).with(%i(enable disable))}

    context "Name invalid" do
      before {subject.name = nil}
      it {expect(subject).not_to be_valid}
    end

    context "Category id invalid" do
      before {subject.category_id = "a"}
      it {expect(subject).not_to be_valid}
    end

    context "Price numericality invalid" do
      before {subject.price = "Rails"}
      it {expect(subject).not_to be_valid}
    end

    context "Price greater than invalid" do
      before {subject.price = Settings.factories.products.price_min_invalid}
      it {expect(subject).not_to be_valid}
    end

    context "Stock greater than invalid" do
      before {subject.price = Settings.factories.products.stock_min_invalid}
      it {expect(subject).not_to be_valid}
    end
  end

  describe "Scopes" do
    let!(:c00){Category.create(name: "ACategory")}
    let!(:c01){Category.create(name: "BCategory")}
    let!(:p00){Product.create(name: "Coca", category_id: c00.id, price: 1000, stock: 20, status: 1)}
    let!(:p01){Product.create(name: "Pepsi", category_id: c01.id, price: 2000, stock: 15, status: 0)}
    let!(:p02){Product.create(name: "Fanta", category_id: c01.id, price: 1500, stock: 13, status: 0)}
    context "Order by name asc" do
      it {expect(Product.order_name_asc).to eq [p00, p02, p01]}
    end

    context "Order by name desc" do
      it {expect(Product.order_name_desc).to eq [p01, p02, p00]}
    end

    context "Order by price asc" do
      it {expect(Product.order_price_asc).to eq [p00, p02, p01]}
    end

    context "Order by price desc" do
      it {expect(Product.order_price_desc).to eq [p01, p02, p00]}
    end

    context "Order by stock asc" do
      it {expect(Product.order_stock_asc).to eq [p02, p01, p00]}
    end

    context "Order by stock desc" do
      it {expect(Product.order_stock_desc).to eq [p00, p01, p02]}
    end

    context "Order by category asc" do
      it {expect(Product.order_category_asc).to eq [p00, p01, p02]}
    end

    context "Order by category desc" do
      it {expect(Product.order_category_desc).to eq [p01, p02, p00]}
    end

    context "Order available" do
      it {expect(Product.available).to eq [p01, p02]}
    end

    context "Order search by name" do
      it {expect(Product.search_by_name("ca")).to eq [p00]}
    end
  end
end
