# frozen_string_literal: true

RSpec.describe YFantasy::Ref::Nfl do
  it "has 32 teams" do
    expect(described_class::TEAM_KEY_MAP.values.size).to eq(32)
  end

  describe ".team" do
    it "returns team data for the given team key" do
      expected = {abbrev: "nyj", city: "New York", key: "nfl.t.20", team_name: "Jets"}
      expect(described_class.team("nfl.t.20")).to eq(expected)
    end
  end
end
