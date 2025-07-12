# frozen_string_literal: true

RSpec.describe YFantasy::Api::Authentication, :api do
  before do
    YFantasy.config.yahoo_client_id = nil
    YFantasy.config.yahoo_client_secret = nil
    YFantasy.config.yahoo_username = nil
    YFantasy.config.yahoo_password = nil
    YFantasy.config.yahoo_refresh_token = nil
  end

  after do
    described_class.instance_variable_set(:@access_token, nil)
    described_class.instance_variable_set(:@expires_in_seconds, nil)
    described_class.instance_variable_set(:@refresh_token, nil)
  end

  describe ".authenticate" do
    context "when the access token is still valid" do
      it "returns true" do
        allow(described_class).to receive(:access_token_valid?).and_return(true)
        expect(described_class.authenticate).to be(true)
      end
    end

    context "with refresh token" do
      before do
        allow(described_class).to receive(:refresh_token?).and_return(true)
        allow(described_class).to receive(:refresh_token).and_return("fake_refresh_token")
      end

      it "calls .authenticate_with_refresh_token" do
        expect(described_class).to receive(:authenticate_with_refresh_token).once
        described_class.authenticate
      end

      it "sets token data" do
        expect(described_class).to receive(:authenticate_with_refresh_token).and_call_original
        described_class.authenticate
        expect(described_class.access_token).to eq("fake_access_token")
        expect(described_class.expires_at - Time.now.to_i).to be > 3595 # Should be 3600, providing some buffer for specs
        expect(described_class.refresh_token).to eq("fake_refresh_token")
      end
    end

    context "with refresh token set in YFantasy.config" do
      before do
        YFantasy.config.yahoo_refresh_token = "fake_refresh_token"
      end

      it "calls .authenticate_with_refresh_token" do
        expect(described_class).to receive(:authenticate_with_refresh_token).once
        described_class.authenticate
      end

      it "sets token data" do
        expect(described_class).to receive(:authenticate_with_refresh_token).and_call_original
        described_class.authenticate
        expect(described_class.access_token).to eq("fake_access_token")
        expect(described_class.expires_at - Time.now.to_i).to be > 3595 # Should be 3600, providing some buffer for specs
        expect(described_class.refresh_token).to eq("fake_refresh_token")
      end
    end

    context "with authorization code" do
      before do
        YFantasy.config.yahoo_refresh_token = nil
      end

      it "calls .authenticate_with_code" do
        expect(described_class).to receive(:authenticate_with_code).once
        described_class.authenticate
      end

      it "sets token data" do
        expect(described_class).to receive(:authenticate_with_code).and_call_original
        expect(described_class).to receive(:get_auth_code).and_return("fake_code")
        described_class.authenticate
        expect(described_class.access_token).to eq("fake_access_token")
        expect(described_class.expires_at - Time.now.to_i).to be > 3595 # Should be 3600, providing some buffer for specs
        expect(described_class.refresh_token).to eq("fake_refresh_token")
      end
    end
  end
end
