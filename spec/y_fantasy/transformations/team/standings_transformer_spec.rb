# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::Team::StandingsTransformer do
  describe "#call" do
    context "when a team_stats key does not exist" do
      let(:data) do
        {
          team_key: "123.l.456789.t.1",
          team_standings: {
            outcome_totals: {
              wins: 10,
              losses: 4,
              ties: 0,
              percentage: 0.714
            },
            divisional_outcome_totals: {
              wins: 6,
              losses: 2,
              ties: 0
            }
          }
        }
      end

      let(:expected) do
        {
          team_key: "123.l.456789.t.1",
          team_standings: {
            total_wins: 10,
            total_losses: 4,
            total_ties: 0,
            win_percentage: 0.714,
            divisional_wins: 6,
            divisional_losses: 2,
            divisional_ties: 0
          }
        }
      end

      it "removes the nesting from the team_standings hash" do
        expect(described_class.new.call(data)).to eq(expected)
      end
    end
  end
end
