require 'features_helper'

RSpec.describe 'Register new user', type: :feature do
  let(:repository) { UserRepository.new }
  let(:sign_up_link) { "Don't have account? Create one from here!" }

  context 'when data valid' do
    it 'new user signed up' do
      visit Main.routes.root_path

      click_link sign_up_link
      expect(page.current_path).to eq Main.routes.sign_up_path

      fill_in name: 'user[username]', with: 'new-user'
      fill_in name: 'user[email]', with: 'new@mail.com'
      fill_in name: 'user[password]', with: '123'
      fill_in name: 'user[password_confirmation]', with: '123'
      click_button 'Sign Up'

      created_user = repository.find_by_email_with_profile('new@mail.com')

      expect(created_user.email).to eq 'new@mail.com'
      expect(created_user.username).to eq created_user.profile.name
    end
  end

  context 'when data invalid' do
    it 'failed to register new user' do
      visit Main.routes.root_path

      click_link sign_up_link
      expect(page.current_path).to eq Main.routes.sign_up_path

      fill_in name: 'user[username]', with: 'new-user'
      fill_in name: 'user[email]', with: 'new@mail.com'
      fill_in name: 'user[password]', with: '123'
      click_button 'Sign Up'

      expect(repository.first).to be_nil
      expect(page).to have_content %(must be equal to 123)
    end
  end
end
