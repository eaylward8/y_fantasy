# frozen_string_literal: true

RSpec.describe YFantasy::Matchup do
  describe "#winning_team" do
    it "returns winning team if not tied" do
      matchup = described_class.new(**attributes_for(:matchup_with_teams, :with_winner))
      winning_team = matchup.winning_team
      expect(winning_team).to be_instance_of(YFantasy::Team)
      expect(winning_team.team_key).to eq(matchup.winner_team_key)
    end

    it "returns nil if tied" do
      matchup = described_class.new(**attributes_for(:matchup, is_tied: true))
      expect(matchup.winning_team).to be nil
    end
  end

  describe "#losing_team" do
    it "returns losing team if not tied" do
      matchup = described_class.new(**attributes_for(:matchup_with_teams, :with_winner))
      losing_team = matchup.losing_team
      expect(losing_team).to be_instance_of(YFantasy::Team)
      expect(losing_team.team_key).to_not eq(matchup.winner_team_key)
    end
  end

  describe "team points methods" do
    let(:matchup) { described_class.new(**attributes_for(:matchup)) }
    let(:team) { instance_double(YFantasy::Team) }
    let(:stat_collection) { double("stat collection") }
    let(:team_points) { double("team points") }
    let(:team_proj_points) { double("team projected points") }

    before do
      allow(team).to receive(:stats).and_return(stat_collection)
      allow(stat_collection).to receive(:team_points).and_return(team_points)
      allow(stat_collection).to receive(:team_projected_points).and_return(team_proj_points)
    end

    describe "#winner_total_points" do
      it "returns winning team's total points" do
        allow(matchup).to receive(:winning_team).and_return(team)
        allow(team_points).to receive(:total).and_return(100)
        expect(matchup.winner_total_points).to eq(100)
      end
    end

    describe "#loser_total_points" do
      it "returns losing team's total points" do
        allow(matchup).to receive(:losing_team).and_return(team)
        allow(team_points).to receive(:total).and_return(99)

        expect(matchup.loser_total_points).to eq(99)
      end
    end

    describe "#winner_proj_points" do
      it "returns winning team's projected total points" do
        allow(matchup).to receive(:winning_team).and_return(team)
        allow(team_proj_points).to receive(:total).and_return(120)

        expect(matchup.winner_proj_points).to eq(120)
      end
    end

    describe "#loser_proj_points" do
      it "returns losing team's projected total points" do
        allow(matchup).to receive(:losing_team).and_return(team)
        allow(team_proj_points).to receive(:total).and_return(110)

        expect(matchup.loser_proj_points).to eq(110)
      end
    end
  end

  describe "#scores" do
    let(:matchup) { described_class.new(**attributes_for(:matchup)) }
    let(:team1) { double("Team 1").as_null_object }
    let(:team2) { double("Team 2").as_null_object }

    it "returns an array of hashes with team data" do
      allow(matchup).to receive(:teams).and_return([team1, team2])
      scores = matchup.scores
      expect(scores).to be_instance_of(Array)
      scores.each do |score|
        expect(score.keys).to include(:team_key, :team_name, :total, :proj_total)
      end
    end
  end
end
