# frozen_string_literal: true

RSpec.describe YFantasy::Transformations do
  describe ".transformer_for" do
    it "returns the appropriate transformer instance" do
      expect(described_class.transformer_for(:league)).to be_instance_of(YFantasy::Transformations::LeagueTransformer)
      expect(described_class.transformer_for(:team, nested: true)).to be_instance_of(YFantasy::Transformations::TeamTransformer)
    end
  end

  describe "transformer methods" do
    it ".game_transformer" do
      described_class.game_transformer
      expect(described_class.class_variable_get(:@@game_transformer)).to_not be_nil
    end

    it ".group_transformer" do
      described_class.group_transformer
      expect(described_class.class_variable_get(:@@group_transformer)).to_not be_nil

      described_class.group_transformer(nested: true)
      expect(described_class.class_variable_get(:@@group_transformer_nested)).to_not be_nil
    end

    it ".league_transformer" do
      described_class.league_transformer
      expect(described_class.class_variable_get(:@@league_transformer)).to_not be_nil
    end

    it ".pickem_team_transformer" do
      described_class.pickem_team_transformer
      expect(described_class.class_variable_get(:@@pickem_team_transformer)).to_not be_nil

      described_class.pickem_team_transformer(nested: true)
      expect(described_class.class_variable_get(:@@pickem_team_transformer_nested)).to_not be_nil
    end

    it ".player_transformer" do
      described_class.player_transformer
      expect(described_class.class_variable_get(:@@player_transformer)).to_not be_nil

      described_class.player_transformer(nested: true)
      expect(described_class.class_variable_get(:@@player_transformer_nested)).to_not be_nil
    end

    it ".team_transformer" do
      described_class.team_transformer
      expect(described_class.class_variable_get(:@@team_transformer)).to_not be_nil

      described_class.team_transformer(nested: true)
      expect(described_class.class_variable_get(:@@team_transformer_nested)).to_not be_nil
    end
  end
end
