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
          fn = t(:map_value, :team_standings, transform_record_data)
          t(:guard, ->(data) { data.key?(:team_standings) }, fn)
        end

        def transform_record_data
          lambda do |data|
            if data[:outcome_totals]
              data[:total_wins] = data.dig(:outcome_totals, :wins)
              data[:total_losses] = data.dig(:outcome_totals, :losses)
              data[:total_ties] = data.dig(:outcome_totals, :ties)
              data[:win_percentage] = data.dig(:outcome_totals, :percentage)
              data.delete(:outcome_totals)
            end

            if data[:divisional_outcome_totals]
              data[:divisional_wins] = data.dig(:divisional_outcome_totals, :wins)
              data[:divisional_losses] = data.dig(:divisional_outcome_totals, :losses)
              data[:divisional_ties] = data.dig(:divisional_outcome_totals, :ties)
              data.delete(:divisional_outcome_totals)
            end

            data
          end
        end
      end
    end
  end
end
