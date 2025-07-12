# frozen_string_literal: true

RSpec.describe YFantasy::Api::Client do
  let(:client) { described_class.new }

  describe ".get" do
    it "calls #get on a new instance" do
      instance = instance_double(described_class)
      expect(described_class).to receive(:new).and_return(instance)
      expect(instance).to receive(:get).with("game", "nfl", [:game_weeks], scope_to_user: true)

      described_class.get("game", "nfl", [:game_weeks], scope_to_user: true)
    end
  end

  describe "#get" do
    before do
      allow(YFantasy::Api::Authentication).to receive(:authenticate).and_return(true)
      allow(YFantasy::Api::Authentication).to receive(:access_token).and_return("fake_access_token")
      allow(YFantasy::Api::Authentication).to receive(:refresh_token).and_return("fake_refresh_token")
    end

    context "when requesting a resource" do
      before do
        stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl")
          .to_return(status: 200, body: Fixture.load("resources/raw/game_nfl.xml"))
      end

      it "parses xml and returns a hash" do
        actual = client.get("game", "nfl")
        expected = Fixture.load_yaml("resources/parsed/game_nfl.yaml")
        expect(actual).to eq(expected)
      end

      context "with subresources" do
        before do
          stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl;out=game_weeks")
            .to_return(status: 200, body: Fixture.load("resources/raw/game_nfl_game_weeks.xml"))
        end

        it "parses xml and returns a hash" do
          actual = client.get("game", "nfl", [:game_weeks])
          expected = Fixture.load_yaml("resources/parsed/game_nfl_game_weeks.yaml")
          expect(actual).to eq(expected)
        end
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

      context "with subresources" do
        before do
          stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/games;game_keys=nfl,nba;out=roster_positions")
            .to_return(status: 200, body: Fixture.load("resources/raw/games_nfl_nba_roster_positions.xml"))
        end

        it "parses xml and returns a hash" do
          actual = client.get("games", %w[nfl nba], [:roster_positions])
          expected = Fixture.load_yaml("resources/parsed/games_nfl_nba_roster_positions.yaml")
          expect(actual).to eq(expected)
        end
      end
    end

    context "4xx response" do
      before do
        stub_request(:get, "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl")
          .to_return(status: 401, body: Fixture.load("resources/raw/401.xml"))
      end

      it "raises" do
        expect { client.get("game", "nfl") }.to raise_error(RuntimeError, /Please provide valid credentials/)
      end
    end
  end
end
