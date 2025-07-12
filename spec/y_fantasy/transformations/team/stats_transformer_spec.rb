# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::Team::StatsTransformer do
  describe "#call" do
    context "when a team_stats key does not exist" do
      let(:data) do
        {
          other_data: {},
          team_points: {},
          team_projected_points: {},
          team_remaining_games: {}
        }
      end

      let(:expected) do
        {
          other_data: {},
          stats: {
            team_points: {},
            team_projected_points: {},
            team_remaining_games: {}
          }
        }
      end

      it "nests team_points and team_projected_points under stats" do
        expect(described_class.new.call(data)).to eq(expected)
      end
    end

    context "when a team_stats key already exists" do
      let(:data) do
        {
          other_data: {},
          team_stats: {
            stat1: 1,
            stat2: 2
          },
          team_points: {},
          team_projected_points: {},
          team_remaining_games: {}
        }
      end

      let(:expected) do
        {
          other_data: {},
          stats: {
            team_stats: {
              stat1: 1,
              stat2: 2
            },
            team_points: {},
            team_projected_points: {},
            team_remaining_games: {}
          }
        }
      end

      it "nests team_points and team_projected_points under team_stats, along with original data" do
        expect(described_class.new.call(data)).to eq(expected)
      end
    end
  end
end
