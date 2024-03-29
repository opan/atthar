RSpec.describe Main::Controllers::Landing::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash['warden' => @warden] }

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end
end
