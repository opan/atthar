require 'features_helper'

RSpec.describe 'Create new organization', type: :feature do
  let(:org_repo) { OrgRepository.new }
  let(:admin_role) { Factory[:org_member_role, name: 'admin'] }

  context 'with valid user' do
    before(:each) do
      admin_role
    end

    it 'create new organization' do
      login

      click_link 'Organization'

      expect(page).to have_content %(New organization)

      click_link 'New organization'

      fill_in name: 'org[name]', with: 'pt. new world order, tbk'
      fill_in name: 'org[display_name]', with: 'PT New World Order'
      fill_in name: 'org[address]', with: Faker::Address.street_address
      fill_in name: 'org[phone_numbers]', with: Faker::PhoneNumber.cell_phone
      click_button 'Create'

      expect(page).to have_current_path Admin.routes.orgs_path
      expect(page).to have_content 'pt. new world order, tbk'
    end

    context 'with invalid input' do
      it 'failed create new organization' do
        login

        click_link 'Organization'

        expect(page).to have_content %(New organization)

        click_link 'New organization'

        fill_in name: 'org[display_name]', with: 'PT New World Order'
        fill_in name: 'org[address]', with: Faker::Address.street_address
        fill_in name: 'org[phone_numbers]', with: Faker::PhoneNumber.cell_phone
        click_button 'Create'

        expect(page).to have_current_path Admin.routes.orgs_path
        expect(page).to have_content 'Name must be filled'
      end
    end
  end

  context 'with invalid user' do
    it 'cannot create new organization' do
      visit Admin.routes.orgs_path

      expect(page).not_to have_current_path Admin.routes.orgs_path
      expect(page).to have_content %(Don't have account? Create one from here!)
    end

    it 'cannot see other organization' do
      admin_role
      org_member = Factory[:org_member]
      org = org_repo.find(org_member.org_id)

      login

      click_link 'Organizations'
      expect(page).not_to have_content org.display_name
    end
  end
end
