require 'spec_helper'
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
end
