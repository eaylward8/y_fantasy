# frozen_string_literal: true

module YFantasy
  module Transformations
    def self.transformer_for(resource, nested: false)
      method = "#{resource}_transformer"
      nested ? public_send(method, nested: true) : public_send(method)
    end

    def self.game_transformer
      @@game_transformer ||= GameTransformer.new
    end

    def self.league_transformer
      @@league_transformer ||= LeagueTransformer.new
    end

    def self.player_transformer(nested: false)
      if nested
        @@player_transformer_nested ||= PlayerTransformer.new(nested: true)
      else
        @@player_transformer ||= PlayerTransformer.new
      end
    end

    def self.team_transformer(nested: false)
      if nested
        @@team_transformer_nested ||= TeamTransformer.new(nested: true)
      else
        @@team_transformer ||= TeamTransformer.new
      end
    end
  end
end
