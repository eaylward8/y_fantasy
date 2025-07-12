# frozen_string_literal: true

module YFantasy
  module Transformations
    class PickemTeamTransformer < BaseTransform
      def initialize(nested: false)
        @nested = nested
        @function = compose_function
        super(nested)
      end

      private

      def compose_function
        t(:guard, ->(data) { data.key?(:team) }, t(:unwrap, :team))
          .>> rename_team_name_to_name
          .>> transform_manager
          .>> transform_week_picks
          .>> instantiate
      end

      # When a team is returned by itself, or as a Group subresource, it has the key `name`.
      # When a team is returned inside Group standings, it has the key `team_name`.
      def rename_team_name_to_name
        t(:rename_keys, team_name: :name)
      end

      def transform_manager
        Team::ManagerTransformer.new
      end

      def transform_week_picks
        PickemTeam::WeekPicksTransformer.new
      end

      def instantiate
        @nested ? t(:no_op) : Instantiator.new(YFantasy::PickemTeam)
      end
    end
  end
end
