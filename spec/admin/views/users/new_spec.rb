RSpec.describe Admin::Views::Users::New, type: :view do
  let(:current_user) { double('user', id: 1) }
  let(:exposures) { Hash[format: :html, user: User.new, params: {}, flash: {}, current_user: current_user] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/users/new.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it 'exposes #user' do
    expect(view.user).to eq exposures.fetch(:user)
  end

  context 'user form' do
    it 'show username input' do
      expect(rendered).to match(/name\="user\[username\]"/)
    end

    it 'show email input' do
      expect(rendered).to match(/name\="user\[email\]"/)
    end
  end
end
