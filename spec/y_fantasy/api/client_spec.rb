# frozen_string_literal: true

RSpec.describe YFantasy::Api::Client do
  let(:client) { described_class.new }

  describe "#get" do
    before do
      allow(YFantasy::Api::Authentication).to receive(:authenticate).and_return(true)
      allow(YFantasy::Api::Authentication).to receive(:access_token).and_return("fake_access_token")
      allow(YFantasy::Api::Authentication).to receive(:refresh_token).and_return("fake_refresh_token")
    end

    context "when requesting resource" do
      before do
        stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl")
          .to_return(status: 200, body: Fixture.load("resources/raw/game_nfl.xml"))
      end

      it "parses xml and returns a hash" do
        actual = client.get("game", "nfl")
        expected = Fixture.load_yaml("resources/parsed/game_nfl.yaml")
        expect(actual).to eq(expected)
      end
    end

    context "when requesting a collection" do
      before do
        stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/games;game_keys=nfl,nba")
          .to_return(status: 200, body: Fixture.load("resources/raw/games_nfl_nba.xml"))
      end

      it "parses xml and returns a hash" do
        actual = client.get("games", %w[nfl nba])
        expected = Fixture.load_yaml("resources/parsed/games_nfl_nba.yaml")
        expect(actual).to eq(expected)
      end
    end
  end
end
