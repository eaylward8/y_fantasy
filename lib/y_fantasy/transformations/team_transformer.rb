# frozen_string_literal: true

module YFantasy
  module Transformations
    class TeamTransformer < BaseTransform
      def initialize(include_matchups: true)
        @include_matchups = include_matchups
        puts "Incl matchups: #{@include_matchups}"
        @function = compose_function
        super(include_matchups)
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
          .>> Instantiator.new(YFantasy::Team)
      end

      def transform_managers
        Team::ManagerTransformer.new
      end

      def transform_draft_results
        DefaultTransformer.new(:draft_results)
      end

      def transform_matchups
        @include_matchups ? MatchupsTransformer.new : t(->(data) { data })
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
    end
  end
end
