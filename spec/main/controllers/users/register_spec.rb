RSpec.describe Main::Controllers::Users::Register, type: :action do
  let(:params) { Hash[user: {}, 'warden' => @warden] }

  context 'with valid params' do
    let(:action) { described_class.new }

    before(:each) do
      params[:user] =  {
        email: 'foo@email.com',
        username: 'foo',
        password: 'foo',
        password_confirmation: 'foo',
      }

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response).to have_http_status 302
    end

    it 'redirects to ' + Main.routes.root_path do
      expect(@response).to redirect_to Main.routes.root_path
    end
  end

  context 'with invalid params' do
    let(:action) { described_class.new }

    before(:each) do
      params[:user] =  {
        email: 'foo@email.com',
        username: 'foo',
      }

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response).to have_http_status 302
    end

    it 'invalid params error messages' do
      flash = action.exposures[:flash]
      expect(flash[:errors]).to eq ['Password ["is missing"]']
    end

    it 'redirects to /sign_up' do
      expect(@response).to redirect_to Main.routes.sign_up_path
    end
  end

  context 'when email alrady exists' do
    let(:user_repo) {instance_double(UserRepository, find_by_email: User.new) }
    let(:action) { described_class.new(user_repo: user_repo) }

    before(:each) do
      params[:user] =  {
        email: 'foo@email.com',
        username: 'foo',
        password: 'foo',
        password_confirmation: 'foo',
      }

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response).to have_http_status 302
    end

    it 'invalid error messages' do
      flash = action.exposures[:flash]
      expect(flash[:errors]).to eq ['email already exists']
    end

    it 'redirects to /sign_up' do
      expect(@response).to redirect_to Main.routes.sign_up_path
    end
  end
end
