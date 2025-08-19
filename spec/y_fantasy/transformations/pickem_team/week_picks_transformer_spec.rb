# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::PickemTeam::WeekPicksTransformer do
  describe "#call" do
    context "when picks are present" do
      let(:data) do
        {
          team_key: "123.g.45678.t.1",
          week_picks: {
            week_pick: [
              {week: "1", picks_completed: "1", picks: {pick: {team: "nfl.t.1", result: "correct", locked: "1"}}},
              {week: "2", picks_completed: "1", picks: {pick: {team: "nfl.t.2", result: "strike", locked: "1"}}}
            ]
          }
        }
      end

      let(:expected) do
        {
          team_key: "123.g.45678.t.1",
          week_picks: [
            {week: "1", picks_completed: "1", picks: [{team: "nfl.t.1", result: "correct", locked: "1"}]},
            {week: "2", picks_completed: "1", picks: [{team: "nfl.t.2", result: "strike", locked: "1"}]}
          ]
        }
      end

      it "transforms `week_picks` value and inner `picks` value for each week_pick" do
        expect(described_class.new.call(data)).to eq(expected)
      end
    end

    context "when picks are NOT present" do
      let(:data) do
        {
          team_key: "123.g.45678.t.1",
          week_picks: {
            week_pick: [
              {week: "1", picks_completed: "1", picks: {pick: {team: "nfl.t.1", result: "correct", locked: "1"}}},
              {week: "2", picks_completed: nil, picks: nil}
            ]
          }
        }
      end

      let(:expected) do
        {
          team_key: "123.g.45678.t.1",
          week_picks: [
            {week: "1", picks_completed: "1", picks: [{team: "nfl.t.1", result: "correct", locked: "1"}]},
            {week: "2", picks_completed: nil, picks: []}
          ]
        }
      end

      it "transforms `week_picks` value and inner `picks` value (empty array)" do
        expect(described_class.new.call(data)).to eq(expected)
      end
    end

    context "when there is only a single week_pick (hash, not array)" do
      let(:data) do
        {
          team_key: "123.g.45678.t.1",
          week_picks: {
            week_pick: {
              week: "1", picks_completed: "1", picks: {pick: {team: "nfl.t.1", result: "correct", locked: "1"}}
            }
          }
        }
      end

      let(:expected) do
        {
          team_key: "123.g.45678.t.1",
          week_picks: [
            {week: "1", picks_completed: "1", picks: [{team: "nfl.t.1", result: "correct", locked: "1"}]}
          ]
        }
      end

      it "transforms `week_picks` value to array and inner `picks` value" do
        expect(described_class.new.call(data)).to eq(expected)
      end
    end
  end
end
