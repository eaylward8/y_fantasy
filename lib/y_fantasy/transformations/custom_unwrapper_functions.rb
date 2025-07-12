# frozen_string_literal: true

module YFantasy
  module Transformations
    module CustomUnwrapperFunctions
      extend Dry::Transformer::Registry
      import T

      def self.stat_categories
        t(:map_value, :stat_categories, t(:dig_value, :stats, :stat))
      end

      def self.stat_modifiers
        t(:map_value, :stat_modifiers, t(:dig_value, :stats, :stat))
      end

      def self.settings
        resources = YFantasy::Settings.subresources
        t(:map_value, :settings, ->(data) { ResourceUnwrapper.new(resources).call(data) })
      end

      # TODO: need to differentiate this from League standings
      def self.standings
        t(:rename_keys, team_standings: :standings) >> t(:map_value, :standings, t(:unwrap, :outcome_totals))
      end

      def self.roster
        t(:map_value, :roster, ->(data) { ResourceUnwrapper.new(:players).call(data) })
      end
    end
  end
end
