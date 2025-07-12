# frozen_string_literal: true

RSpec.describe YFantasy::Api::Authentication do
  describe ".authenticate" do
    context "when the access token is still valid" do
      it "returns true" do
        allow(described_class).to receive(:access_token_valid?).and_return(true)
        expect(described_class.authenticate).to be(true)
      end
    end
  end
end
