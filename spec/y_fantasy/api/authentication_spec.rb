# frozen_string_literal: true

RSpec.describe YFantasy::Api::Authentication, :api, :suppress_output do
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

      context "when using automated login" do
        before do
          YFantasy.config.automate_login = true
        end

        it "calls .authenticate_with_code" do
          expect(described_class).to receive(:authenticate_with_code).once
          described_class.authenticate
        end

        it "sets token data automatically" do
          expect(described_class).to receive(:authenticate_with_code).and_call_original
          expect(described_class).to receive(:get_auth_code_automated).and_return("fake_code")
          described_class.authenticate
          expect(described_class.access_token).to eq("fake_access_token")
          expect(described_class.expires_at - Time.now.to_i).to be > 3595 # Should be 3600, providing some buffer for specs
          expect(described_class.refresh_token).to eq("fake_refresh_token")
        end
      end

      context "when using manual login" do
        before do
          YFantasy.config.automate_login = false
        end

        it "receives auth code as user input to complete the auth process" do
          expect(described_class).to receive(:authenticate_with_code).and_call_original
          expect(described_class).to receive(:get_auth_code_manual).and_call_original
          expect($stdin).to receive(:gets).and_return("fake_code")
          described_class.authenticate
          expect(described_class.access_token).to eq("fake_access_token")
          expect(described_class.expires_at - Time.now.to_i).to be > 3595 # Should be 3600, providing some buffer for specs
          expect(described_class.refresh_token).to eq("fake_refresh_token")
        end
      end
    end

    context "when an error response is received" do
      before do
        YFantasy.config.yahoo_refresh_token = "fake_refresh_token"
      end

      it "returns false and sets error data" do
        json = '{"error":401,"error_description":"Uh oh"}'
        dbl = double("HTTP Error", body: json)
        allow(described_class).to receive(:post).and_return(dbl)
        allow(Net::HTTPClientError).to receive(:===).and_return(true) # mock case statement

        expect(described_class.authenticate).to be(false)
        expect(described_class.error_type).to eq(401)
        expect(described_class.error_desc).to eq("Uh oh")
      end
    end
  end
end
