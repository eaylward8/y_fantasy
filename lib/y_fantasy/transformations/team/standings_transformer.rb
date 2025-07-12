# frozen_string_literal: true

module YFantasy
  module Transformations
    module Team
      class StandingsTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          fn = t(:rename_keys, team_standings: :standings) >> t(:map_value, :standings, t(:unwrap, :outcome_totals))
          t(:guard, ->(data) { data.key?(:team_standings) }, fn)
        end
      end
    end
  end
end
