# frozen_string_literal: true

RSpec.describe YFantasy::Api::UrlBuilder do
  describe ".build" do
    context "with a singular resource" do
      context "with no subresources" do
        it "builds a resource URL" do
          builder = described_class.new("game", keys: "nfl")
          expect(builder.build).to eq("https://fantasysports.yahooapis.com/fantasy/v2/game/nfl")
        end
      end

      context "with one subresource" do
        it "builds a resource URL with 'slash' params" do
          builder = described_class.new("game", keys: "nfl", subresources: [:game_weeks])
          expected_url = "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl/game_weeks"
          expect(builder.build).to eq(expected_url)
        end
      end

      context "with multiple subresources" do
        it "builds a resource URL with 'out' params" do
          builder = described_class.new("game", keys: "nfl", subresources: [:game_weeks, :roster_positions])
          expected_url = "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl;out=game_weeks,roster_positions"
          expect(builder.build).to eq(expected_url)
        end
      end

      context "with nested subresources" do
        it "builds a resource URL with 'out' and 'slash' params" do
          builder = described_class.new("league", keys: "123.l.456789", subresources: [:draft_results, {teams: :matchups}])
          expected_url = "https://fantasysports.yahooapis.com/fantasy/v2/league/123.l.456789;out=draftresults/teams/matchups"
          expect(builder.build).to eq(expected_url)
        end
      end
    end

    context "with a plural resource (aka collection)" do
      context "with no subresources" do
        it "builds a collection URL" do
          builder = described_class.new("games", keys: "nfl")
          expect(builder.build).to eq("https://fantasysports.yahooapis.com/fantasy/v2/games;game_keys=nfl")
        end
      end

      context "with subresources" do
        it "builds a resource URL with 'out' params" do
          builder = described_class.new("games", keys: "nfl", subresources: [:game_weeks, :roster_positions])
          expected_url = "https://fantasysports.yahooapis.com/fantasy/v2/games;game_keys=nfl;out=game_weeks,roster_positions"
          expect(builder.build).to eq(expected_url)
        end
      end
    end

    context "with game_codes" do
      context "with the 'games' collection" do
        it "builds a collection URL with game_codes" do
          builder = described_class.new("games", game_codes: ["nfl", "nfls"])
          expect(builder.build).to eq("https://fantasysports.yahooapis.com/fantasy/v2/games;game_codes=nfl,nfls")
        end
      end

      context "with another resource/collection" do
        it "raises" do
          builder = described_class.new("leagues", game_codes: "nfl")
          expect { builder.build }.to raise_error(YFantasy::Api::UrlBuilder::Error)
        end
      end

      context "with keys" do
        it "raises" do
          builder = described_class.new("leagues", keys: "nfl", game_codes: "nfl")
          expect { builder.build }.to raise_error(YFantasy::Api::UrlBuilder::Error)
        end
      end
    end
  end
end
