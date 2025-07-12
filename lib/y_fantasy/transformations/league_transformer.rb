# frozen_string_literal: true

module YFantasy
  module Transformations
    class LeagueTransformer < BaseTransform
      def initialize(nested: false)
        @nested = nested
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
          .>> instantiate
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
        # wrap_in_array is needed when there is only 1 team. This can happen when requesting data scoped to current user.
        DefaultTransformer.new(:teams) >> t(:map_value, :teams, t(:wrap_in_array) >> map_teams_fn)
      end

      def instantiate
        @nested ? t(:no_op) : Instantiator.new(YFantasy::League)
      end
    end
  end
end
