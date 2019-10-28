require "rails_helper"

RSpec.describe Category, type: :model do
  let(:product) { FactoryBot.create :product }
  subject {FactoryBot.build :category}

  describe "Associations" do
    it { is_expected.to have_many(:products).dependent(:nullify) }
  end

  describe "image" do
    it {expect(subject.image).to be_attached}
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name)
      .with_message(I18n.t("activerecord.errors.models.category.attributes.name.blank")) }
    it { is_expected.to validate_uniqueness_of(:name)
      .with_message(I18n.t("activerecord.errors.models.category.attributes.name.taken")) }

    context "name invalid" do
      before {subject.name = nil}
      it {is_expected.not_to be_valid}
    end
  end

  describe "Scopes" do
    let!(:c1) { FactoryBot.create :category, name: "food" }
    let!(:c2) { FactoryBot.create :category, name: "snack" }
    let!(:c3) { FactoryBot.create :category, name: "drink" }

    it "category by default" do
      expect(Category.default).to eq [c1,c2,c3]
    end

    it "category by name_desc" do
      expect(Category.name_desc).to eq [c2,c1,c3]
    end

    it "category by name_asc" do
      expect(Category.name_asc).to eq [c3,c1,c2]
    end

    it "search" do
      expect(Category.search_name("snack")).to eq [c2]
    end
  end
end
