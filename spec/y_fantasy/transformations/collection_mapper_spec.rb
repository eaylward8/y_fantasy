# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::CollectionMapper do
  describe "#call" do
    context "without subresources" do
      let(:data) do
        {
          games: {
            game: [
              {
                game_key: "414",
                game_id: "414",
                name: "Football",
                code: "nfl",
                type: "full",
                url: "https://football.fantasysports.yahoo.com/f1",
                season: "2022",
                is_registration_over: "1",
                is_game_over: "0",
                is_offseason: "0"
              },
              {
                game_key: "418",
                game_id: "418",
                name: "Basketball",
                code: "nba",
                type: "full",
                url: "https://basketball.fantasysports.yahoo.com/nba",
                season: "2022",
                is_registration_over: "0",
                is_game_over: "0",
                is_offseason: "0"
              }
            ]
          }
        }
      end

      it "returns a collection of resource instances" do
        results = described_class.new("games").call(data)
        expect(results).to all(be_a(YFantasy::Game))
      end
    end

    context "with subresources" do
      let(:data) do
        {
          games: {
            game: [
              {
                game_key: "414",
                game_id: "414",
                name: "Football",
                code: "nfl",
                type: "full",
                url: "https://football.fantasysports.yahoo.com/f1",
                season: "2022",
                is_registration_over: "1",
                is_game_over: "0",
                is_offseason: "0",
                game_weeks: {
                  game_week: [
                    {week: "1", display_name: "1", start: "2022-09-08", end: "2022-09-12"},
                    {week: "2", display_name: "2", start: "2022-09-13", end: "2022-09-19"}
                  ]
                }
              },
              {
                game_key: "418",
                game_id: "418",
                name: "Basketball",
                code: "nba",
                type: "full",
                url: "https://basketball.fantasysports.yahoo.com/nba",
                season: "2022",
                is_registration_over: "0",
                is_game_over: "0",
                is_offseason: "0",
                game_weeks: {
                  game_week: [
                    {week: "1", display_name: "1", start: "2022-10-18", end: "2022-10-23"},
                    {week: "2", display_name: "2", start: "2022-10-24", end: "2022-10-30"}
                  ]
                }
              }
            ]
          }
        }
      end

      it "returns a collection of resource instances with subresource instances" do
        results = described_class.new("games", subresources: [:game_weeks]).call(data)

        expect(results).to be_an(Array)
        results.each do |result|
          expect(result.game_weeks).to all(be_a(YFantasy::GameWeek))
        end
      end
    end
  end
end
