# frozen_string_literal: true

RSpec.describe YFantasy::Transformations::Team::RosterTransformer do
  describe "#call" do
    let(:data) { Fixture.load_yaml("resources/team/parsed/team_nfl_with_roster.yaml")}

    it "alters the structure of [:roster][:players]" do
      expect(data[:roster][:players][:player]).to be_instance_of(Array)
      result = described_class.new.call(data)
      expect(result[:roster][:players]).to be_instance_of(Array)
      expect(result[:roster][:players][0][:name][:full]).to eq("Jayden Daniels")
    end

    it "calls the player transformer with nested: true" do
      expect(YFantasy::Transformations).to receive(:player_transformer).with(nested: true).and_call_original
      result = described_class.new.call(data)
    end
  end
end
