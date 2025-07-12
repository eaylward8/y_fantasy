# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::ResourceMapper do
  describe "#call" do
    context "without subresources" do
      let(:data) do
        {
          fantasy_content: {
            game: {
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
            }
          }
        }
      end

      it "returns a resource instance" do
        result = described_class.new("game").call(data)
        expect(result).to be_a(YFantasy::Game)
      end
    end

    context "with 'standard' subresources (plural/singular keys)" do
      let(:data) do
        {
          fantasy_content: {
            game: {
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
            }
          }
        }
      end

      it "returns a resource instance and subresource instances" do
        result = described_class.new("game", subresources: [:game_weeks]).call(data)
        game_weeks = result.game_weeks

        expect(result).to be_a(YFantasy::Game)
        expect(game_weeks).to be_an(Array)
        game_weeks.each do |gw|
          expect(gw).to be_a(YFantasy::Subresources::GameWeek)
        end
      end
    end

    context "with 'non-standard' subresources (non-plural/singular keys)" do
      let(:data) do
        {
          fantasy_content: {
            game: {
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
              stat_categories: {
                stats: {
                  stat: [
                    {stat_id: "1", name: "Passing Attempts", display_name: "Pass Att", sort_order: "1", position_types: {position_type: "O"}},
                    {stat_id: "2", name: "Completions", display_name: "Comp", sort_order: "1", position_types: {position_type: "O"}}
                  ]
                }
              }
            }
          }
        }
      end

      it "returns a resource instance and subresource instances" do
        result = described_class.new("game", subresources: [:stat_categories]).call(data)
        stat_categories = result.stat_categories

        expect(result).to be_a(YFantasy::Game)
        expect(stat_categories).to be_an(Array)
        stat_categories.each do |s|
          expect(s).to be_a(YFantasy::Subresources::Stat)
        end
      end
    end
  end
end
