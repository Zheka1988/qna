require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('MyServices::DailyDigest') }

  before do
    allow(MyServices::DailyDigest).to receive(:new).and_return(service)
  end

  it 'calls MyServices::DailyDigest#send_digest' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
