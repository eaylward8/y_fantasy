# frozen_string_literal: true

RSpec.describe YFantasy::League do
  describe "#started?" do
    it "returns true if current date >= start_date" do
      league = described_class.new(**attributes_for(:league, start_date: Date.today - 1))
      expect(league.started?).to be true
    end

    it "returns false if current date < start_date" do
      league = described_class.new(**attributes_for(:league, start_date: Date.today + 1))
      expect(league.started?).to be false
    end
  end

  describe "#ended?" do
    it "returns true if is_finished is true" do
      league = described_class.new(**attributes_for(:league, is_finished: true))
      expect(league.ended?).to be true
    end

    it "returns true if current date > end_date" do
      league = described_class.new(**attributes_for(:league, end_date: Date.today - 1))
      expect(league.ended?).to be true
    end

    it "returns false if current date < end_date" do
      league = described_class.new(**attributes_for(:league, end_date: Date.today + 1))
      expect(league.ended?).to be false
    end
  end

  describe "#previous_league_key" do
    it "returns the previous league key (renew attribute)" do
      league = described_class.new(**attributes_for(:league))
      expect(league.previous_league_key).to eq "111.l.111111"
    end
  end

  describe "#next_league_key" do
    it "returns the next league key (renewed attribute)" do
      league = described_class.new(**attributes_for(:league))
      expect(league.next_league_key).to eq "222.l.222222"
    end
  end

  describe "#scoreboard_for_week" do
    it "calls League.find to get the scoreboard for a given week" do
      league = described_class.new(**attributes_for(:league))
      expect(league).to receive(:scoreboard)
      expect(described_class).to receive(:find).with(league.league_key, week: 1, with: :scoreboard).and_return(league)
      league.scoreboard_for_week(1)
    end
  end
end
