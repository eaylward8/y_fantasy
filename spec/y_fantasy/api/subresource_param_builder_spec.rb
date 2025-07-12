# frozen_string_literal: true

RSpec.describe YFantasy::Api::SubresourceParamBuilder do
  describe ".build" do
    it "translates subresources for proper URL construction" do
      builder = described_class.new([:draft_results, :ownership_percentage, :team_standings])
      expect(builder.build).to eq(";out=draftresults,percent_owned,standings")
    end

    context "with one subresource" do
      it "returns '/subresource'" do
        builder = described_class.new([:settings])
        expect(builder.build).to eq("/settings")
      end
    end

    context "with multiple subresources" do
      it "returns an 'out' params string" do
        builder = described_class.new([:game_weeks, :roster_positions])
        expect(builder.build).to eq(";out=game_weeks,roster_positions")
      end
    end

    context "with a single nested subresource" do
      it "returns '/subresource/nested_subresource'" do
        builder = described_class.new([{teams: :matchups}])
        expect(builder.build).to eq("/teams/matchups")
      end
    end

    context "with multiple nested subresources" do
      it "returns '/subresource' with 'out' params'" do
        builder = described_class.new([{teams: [:matchups, :team_standings]}])
        expect(builder.build).to eq("/teams;out=matchups,standings")
      end
    end

    context "with non-nested and nested subresources" do
      it "returns a string of 'out' params, followed by nested subresource with its own 'out' params'" do
        builder = described_class.new([:scoreboard, {teams: [:matchups, :team_standings]}])
        expect(builder.build).to eq(";out=scoreboard/teams;out=matchups,standings")
      end
    end

    context "with week" do
      context "with one weekly subresource" do
        it "adds the week param for scoreboard" do
          builder = described_class.new([:scoreboard], week: 8)
          expect(builder.build).to eq("/scoreboard;week=8")
        end

        it "adds the week param for roster" do
          builder = described_class.new([:roster], week: 13)
          expect(builder.build).to eq("/roster;week=13")
        end

        it "adds the weeks param for matchups" do
          builder = described_class.new([:matchups], week: 3)
          expect(builder.build).to eq("/matchups;weeks=3")
        end

        it "adds the 'type=week' and week param for stats" do
          builder = described_class.new([:stats], week: 1)
          expect(builder.build).to eq("/stats;type=week;week=1")
        end
      end

      context "with one non-weekly subresource" do
        it "does not add the week param" do
          builder = described_class.new([:settings], week: 1)
          expect(builder.build).to eq("/settings")
        end
      end

      context "with a combination of non-weekly and weekly subresources" do
        it "adds the week param appropriately" do
          builder = described_class.new([:settings, {teams: :roster}], week: 1)
          expect(builder.build).to eq(";out=settings/teams/roster;week=1")
        end
      end
    end
  end
end
