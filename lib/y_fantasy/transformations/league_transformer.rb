# frozen_string_literal: true

module YFantasy
  module Transformations
    class LeagueTransformer < BaseTransform
      def initialize
        @function = compose_function
        super
      end

      private

      def compose_function
        t(:guard, ->(data) { data.key?(:league) }, t(:unwrap, :league))
          .>> transform_draft_results
          .>> transform_scoreboard
          .>> transform_settings
          .>> transform_standings
          .>> transform_players
          .>> transform_teams
          # .>> Instantiator.new(YFantasy::League)
      end

      def transform_draft_results
        DefaultTransformer.new(:draft_results)
      end

      def transform_scoreboard
        League::ScoreboardTransformer.new
      end

      def transform_settings
        League::SettingsTransformer.new
      end

      def transform_standings
        League::StandingsTransformer.new
      end

      def transform_players
        map_players_fn = t(:map_array, Transformations.player_transformer(nested: true))
        DefaultTransformer.new(:players) >> t(:map_value, :players, map_players_fn)
      end

      def transform_teams
        map_teams_fn = t(:map_array, Transformations.team_transformer(nested: true))
        DefaultTransformer.new(:teams) >> t(:map_value, :teams, map_teams_fn)
      end
    end
  end
end
