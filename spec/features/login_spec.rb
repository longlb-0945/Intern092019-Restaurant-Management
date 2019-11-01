require "rails_helper"

RSpec.feature "Login", type: :feature do
  let!(:guest) {FactoryBot.create :user}
  let!(:staff) {FactoryBot.create :user, role: 1}
  let!(:admin) {FactoryBot.create :user, role: 0}
  before do
    visit login_path
  end

  feature "Login success" do
    scenario "role: guest" do
      fill_in "session[email]", with: guest.email
      fill_in "session[password]", with: Settings.default_password
      click_button "commit"
      expect(page).to have_current_path("/en")
    end

    scenario "role: staff" do
      fill_in "session[email]", with: staff.email
      fill_in "session[password]", with: Settings.default_password
      click_button "commit"
      expect(page).to have_current_path("/en")
    end

    scenario "role: admin" do
      fill_in "session[email]", with: admin.email
      fill_in "session[password]", with: Settings.default_password
      click_button "commit"
      expect(page).to have_current_path("/en")
    end
  end

  feature "Invalid input" do
    scenario "missing email" do
      fill_in "session[password]", with: guest.password
      click_button "commit"
      expect(page).to have_text I18n.t "invalid"
    end

    scenario "missing password" do
      fill_in "session[email]", with: guest.email
      click_button "commit"
      expect(page).to have_text I18n.t "invalid"
    end

    scenario "missing both field" do
      click_button "commit"
      expect(page).to have_text I18n.t "invalid"
    end
  end

  feature "Login failed" do
    scenario "wrong email & password" do
      fill_in "session[email]", with: Settings.fake_email
      fill_in "session[password]", with: "123123"
      click_button "commit"
      expect(page).to have_text I18n.t "invalid"
    end
  end
end
