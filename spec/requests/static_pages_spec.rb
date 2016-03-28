require 'rails_helper'
describe "Статическая страница" do
  describe "Home page" do
    it "должна содердать 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
  end
  describe "Help page" do
    it "должна содержать 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
  end
  describe "About page" do
    it "должна содержать 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end
  end
end
