# frozen_string_literal: true

module YFantasy
  module Transformations
    class TeamTransformer < BaseTransform
      def initialize(nested: false)
        @nested = nested
        @function = compose_function
        super(nested)
      end

      private

      def compose_function
        t(:guard, ->(data) { data.key?(:team) }, t(:unwrap, :team))
          .>> transform_managers
          .>> transform_draft_results
          .>> transform_roster
          .>> transform_standings
          .>> transform_stats
          .>> transform_matchups
          .>> instantiate
      end

      def transform_managers
        Team::ManagerTransformer.new
      end

      def transform_draft_results
        DefaultTransformer.new(:draft_results)
      end

      def transform_matchups
        @nested ? t(:no_op) : MatchupsTransformer.new
      end

      def transform_roster
        Team::RosterTransformer.new
      end

      def transform_standings
        Team::StandingsTransformer.new
      end

      def transform_stats
        Team::StatsTransformer.new
      end

      def instantiate
        @nested ? t(:no_op) : Instantiator.new(YFantasy::Team)
      end
    end
  end
end
