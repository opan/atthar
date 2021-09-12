RSpec.describe Main::Controllers::Orgs::Create, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }
  let(:org_member_role_repo) { instance_double('OrgMemberRoleRepository') }
  let(:action) { described_class.new(org_repo: org_repo, org_member_repo: org_member_repo, org_member_role_repo: org_member_role_repo) }

  let(:user_profile) { @warden.user.profile }
  let(:org_params) { Factory.structs[:org].to_h }
  let(:admin_role) { Factory.structs[:org_member_role_admin] }
  let(:org) { Org.new(org_params) }
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    context 'with valid params' do
      before(:each) do
        params[:org] = org_params.reject! { |k, v| [:created_at, :updated_at, :id].include? k  }
        orgs = [Org.new(Factory.structs[:org, created_by_id: user_profile.id])]

        expect(org_repo).to receive(:all_by_member).with(user_profile.id).and_return(orgs)
        expect(org_member_role_repo).to receive(:get).with('admin').and_return(admin_role)
        expect(org_repo).to receive(:create).with(org).and_return(org)
        expect(org_member_repo).to receive(:create).with(OrgMember.new(
          org_id: org.id,
          org_member_role_id: admin_role.id,
          profile_id: user_profile.id,
        ))

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'got success messages' do
        expect(action.exposures[:flash][:info]).to eq ["Organization #{org.name} has been successfully created"]
      end
    end

    context 'with maximum allowed number has been reached' do
      before(:each) do
        params[:org] = org_params.reject! { |k, v| [:created_at, :updated_at, :id].include? k  }
        max_org = Org.new(Factory.structs[:org, created_by_id: user_profile.id])

        expect(org_repo).to receive(:all_by_member).with(user_profile.id).and_return([max_org, max_org])

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ["You've reach the maximum allowed number to create a new organization"]
      end
    end

    context 'with user already a member in other organization without founder status' do
      before(:each) do
        params[:org] = org_params.reject! { |k, v| [:created_at, :updated_at, :id].include? k  }
        max_org = Org.new(Factory.structs[:org])

        expect(org_repo).to receive(:all_by_member).with(user_profile.id).and_return([max_org, max_org])

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ["You've already registered as a member in an organization which are not created by you"]
      end
    end

    context 'with invalid params' do
      before(:each) do
        params[:org] = org_params.reject! { |k, v| [:created_at, :updated_at, :id, :name].include? k  }

        @response = action.call(params)
      end

      it 'return 422' do
        expect(@response[0]).to eq 422
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ['Name is missing']
      end
    end
  end

end