# frozen_string_literal: true

module YFantasy
  class Team
    class StatCollection < BaseSubresource
      option :team_stats, optional: true, default: -> {} do
        option :coverage_type, optional: true, default: -> {}
        option :season, optional: true, default: -> {}
        # Fully qualified class name needed because nested options create intermediate classes on the fly.
        # At this level we have: YF::Team::StatCollection::TeamStats. TeamStats is created on-the-fly and does not
        # inherit from BaseResource.
        option :stats, optional: true, type: YFantasy::BaseResource.send(:array_of, Stat)
      end

      option :team_points, optional: true, default: -> {} do
        option :coverage_type, optional: true, default: -> {}
        option :season, optional: true, default: -> {}
        option :total, optional: true, default: -> {}
        option :week, optional: true, default: -> {}
      end

      option :team_projected_points, optional: true, default: -> {} do
        option :coverage_type, optional: true, default: -> {}
        option :season, optional: true, default: -> {}
        option :total, optional: true, default: -> {}
        option :week, optional: true, default: -> {}
      end

      option :team_remaining_games, optional: true, default: -> {} do
        option :coverage_type, optional: true, default: -> {}
        option :week, optional: true, default: -> {}
        option :completed_games, optional: true, default: -> {}
        option :live_games, optional: true, default: -> {}
        option :remaining_games, optional: true, default: -> {}
      end

      # TODO: document why this is needed.
      def fetched?
        !!(team_stats || team_points || team_projected_points || team_remaining_games)
      end
    end
  end
end
