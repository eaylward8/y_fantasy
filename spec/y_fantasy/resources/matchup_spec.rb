# frozen_string_literal: true

RSpec.describe YFantasy::Matchup do
  describe "#winning_team" do
    it "returns winning team if not tied" do
      matchup = described_class.new(**attributes_for(:matchup_with_teams, :with_winner))
      expect(matchup.winning_team.team_key).to eq(matchup.winner_team_key)
    end

    it "returns nil if tied" do
      matchup = described_class.new(**attributes_for(:matchup, is_tied: true))
      expect(matchup.winning_team).to be nil
    end
  end
end
