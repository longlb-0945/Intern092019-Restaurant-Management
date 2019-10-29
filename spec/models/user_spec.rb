require "rails_helper"

RSpec.describe User, type: :model do
  subject {FactoryBot.build :user}

  describe "Associations" do
    it { is_expected.to have_many(:rates).dependent(:nullify) }
    it { is_expected.to have_many(:customer_orders).dependent(:destroy) }
    it { is_expected.to have_many(:staff_orders).dependent(:destroy) }
  end

  describe "image" do
    it { expect(subject.image).to be_attached}
  end

  describe "enum" do
    it { is_expected.to define_enum_for(:role).with_values([:admin, :staff, :guest]) }
    it { is_expected.to define_enum_for(:status).with_values([:enable, :disable]) }
  end

  describe "has secure password" do
    it { is_expected.to have_secure_password }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name).with_message(I18n.t("errors_blank")) }
    it { is_expected.to validate_presence_of(:email).with_message(I18n.t("errors_blank")) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive.with_message(I18n.t("errors_taken")) }
    it { is_expected.not_to allow_value("abc@gmail").for(:email).with_message(I18n.t("invalid_errors")) }
    it { is_expected.to validate_presence_of(:password).with_message(I18n.t("errors_blank")) }

    context "name invalid" do
      before {subject.name = nil}
      it {is_expected.not_to be_valid}
    end

    context "Name greater than invalid" do
      before {subject.name = "a" * Settings.factories.user.name_max_length_invalid}
      it {is_expected.not_to be_valid}
    end

    context "Email invalid" do
      before {subject.email = nil}
      it {is_expected.not_to be_valid}
    end

    context "Email greater than invalid" do
      before {subject.email = "a" * Settings.factories.user.name_max_length_invalid}
      it {is_expected.not_to be_valid}
    end

    context "Password greater than invalid" do
      before {subject.password = "a" * Settings.factories.user.password_min_length_invalid}
      it {is_expected.not_to be_valid}
    end
  end

  describe "Scopes" do
    let!(:u1) { FactoryBot.create :user, name: "derrek", email: "derrek@gmail.com", role: 0, status: 0 }
    let!(:u2) { FactoryBot.create :user, name: "fred", email: "fred@gmail.com", role: 1, status: 1 }
    let!(:u3) { FactoryBot.create :user, name: "sam", email: "sam@gmail.com", role: 2, status: 1 }

    it "user by default" do
      expect(User.default).to eq [u1,u2,u3]
    end

    it "user by name_desc" do
      expect(User.name_desc).to eq [u3,u2,u1]
    end

    it "user by name_asc" do
      expect(User.name_asc).to eq [u1,u2,u3]
    end

    it "user by email_asc" do
      expect(User.email_asc).to eq [u1,u2,u3]
    end

    it "user by email_desc" do
      expect(User.email_desc).to eq [u3,u2,u1]
    end

    it "user by status_asc" do
      expect(User.status_asc).to eq [u1,u2,u3]
    end

    it "user by status_desc" do
      expect(User.status_desc).to eq [u2,u3,u1]
    end

    it "user by role_asc" do
      expect(User.role_asc).to eq [u1,u2,u3]
    end

    it "search" do
      expect(User.search("de")).to eq [u1]
    end
  end

  describe "methods" do
    before {subject.remember_digest = Settings.factories.user.fake_remember}
    before {subject.remember}
    let!(:remem_digested) {subject.remember_digest}

    context ".remember" do
      it "to be invalid" do
        expect(subject.remember_digest.size).to eq Settings.remember_digest_size
      end
    end

    context ".authenticated?" do
      it "to be invalid" do
        expect(subject.authenticated? subject.remember_token).to be true
      end
    end

    context ".forget" do
      before {subject.forget}
      it "to be invalid" do
        expect(subject.remember_digest).to be nil
      end
    end

    context ".create_reset_digest" do
      before {subject.create_reset_digest}
      it "to be invalid" do
        expect(subject.reset_digest).not_to be nil
      end
    end

    context ".send_password_reset_email" do
      it {is_expected.to respond_to(:send_password_reset_email) }
    end

    context ".password_reset_expired" do
      it {is_expected.to respond_to(:password_reset_expired?) }
    end
  end
end
