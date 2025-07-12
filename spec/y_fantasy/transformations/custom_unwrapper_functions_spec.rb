# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::CustomUnwrapperFunctions do
  describe ".stat_categories" do
    let(:data) do
      {
        stat_categories: {
          stats: {
            stat: [{a: 1}, {b: 2}]
          }
        }
      }
    end

    let(:expected) do
      {stat_categories: [{a: 1}, {b: 2}]}
    end

    it "unwraps the nested hash" do
      expect(described_class.stat_categories.call(data)).to eq(expected)
    end
  end

  describe ".stat_modifiers" do
    let(:data) do
      {
        stat_modifiers: {
          stats: {
            stat: [{a: 1}, {b: 2}]
          }
        }
      }
    end

    let(:expected) do
      {stat_modifiers: [{a: 1}, {b: 2}]}
    end

    it "unwraps the nested hash" do
      expect(described_class.stat_modifiers.call(data)).to eq(expected)
    end
  end

  describe ".settings" do
    let(:data) do
      {
        settings: {
          draft_type: "live",
          roster_positions: {
            roster_position: [
              {position: "QB"},
              {position: "WR"}
            ]
          },
          stat_categories: {
            stats: {
              stat: [
                {id: 1},
                {id: 2}
              ]
            }
          },
          stat_modifiers: {
            stats: {
              stat: [
                {value: 1},
                {value: 2}
              ]
            }
          }
        }
      }
    end

    let(:expected) do
      {
        settings: {
          draft_type: "live",
          roster_positions: [
            {position: "QB"},
            {position: "WR"}
          ],
          stat_categories: [
            {id: 1},
            {id: 2}
          ],
          stat_modifiers: [
            {value: 1},
            {value: 2}
          ]
        }
      }
    end

    it "transforms the data" do
      expect(described_class.settings.call(data)).to eq(expected)
    end
  end

  describe ".standings (for team)" do
    let(:data) do
      {
        team_standings: {
          rank: "3",
          outcome_totals: {wins: "7", losses: "6", ties: "0", percentage: ".538"},
          streak: {type: "loss", value: "2"},
          points_for: "1223.52",
          points_against: "1230.36"
        }
      }
    end

    let(:expected) do
      {
        standings: {
          rank: "3",
          wins: "7",
          losses: "6",
          ties: "0",
          percentage: ".538",
          streak: {type: "loss", value: "2"},
          points_for: "1223.52",
          points_against: "1230.36"
        }
      }
    end

    it "maps :team_standings to :standings and unwraps :outcome_totals" do
      expect(described_class.standings.call(data)).to eq(expected)
    end
  end

  describe ".roster" do
    let(:data) do
      {
        roster: {
          coverage_type: "week",
          players: {
            player: [
              {player_key: 1}, {player_key: 2}
            ]
          }
        }
      }
    end

    let(:expected) do
      {
        roster: {
          coverage_type: "week",
          players: [
            {player_key: 1}, {player_key: 2}
          ]
        }
      }
    end

    it "unwraps the players data" do
      expect(described_class.roster.call(data)).to eq(expected)
    end
  end
end
