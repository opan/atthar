require 'features_helper'

RSpec.describe 'Update organization', type: :feature do
  let(:org_repo) { OrgRepository.new }
  let(:user_repo) { UserRepository.new }

  let(:admin_role) { Factory[:org_member_role, name: 'admin'] }
  let(:org) { Factory[:org] }
  let(:superadmin) {
    user = Factory[:superadmin_user]
    ProfileRepository.new.create(name: 'superadmin', user_id: user.id)
    user
  }
  let(:org_member) { Factory[:org_member, org_member_role_id: admin_role.id, org_id: org.id] }

  context 'with superadmin access' do
    before(:each) { org_member }

    it 'can update organization details' do
      login user: superadmin

      visit Admin.routes.root_path
      click_link 'Organization'

      expect(page).to have_content org.display_name

      new_display_name = Faker::Name.unique.name

      click_link "#{org.id}-edit-org"
      expect(page).to have_current_path Admin.routes.edit_org_path(id: org.id)

      fill_in 'org[display_name]', with: new_display_name
      click_button 'Update'

      expect(page).to have_current_path Admin.routes.orgs_path
      expect(page).to have_content new_display_name
      expect(page).to have_content 'Organization has been successfully updated'
    end
  end

  context 'with non-superadmin access' do
    before(:each) { org_member }

    it 'cannot update organization details' do
      visit Admin.routes.orgs_path

      expect(page).to have_content %(Don't have account? Create one from here!)
      expect(page).not_to have_current_path Admin.routes.orgs_path
    end

    it 'not able to update organization where user not a member' do
      login

      visit Admin.routes.root_path
      click_link 'Organization'

      expect(page).not_to have_content org.display_name

      visit Admin.routes.edit_org_path(id: org.id)

      expect(page).to have_content 'Organization not found'
      expect(page).to have_current_path Admin.routes.orgs_path
    end
  end
end
