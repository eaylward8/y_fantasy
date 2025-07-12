# frozen_string_literal: true

module YFantasy
  module Transformations
    module Player
      class StatsTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          t(:guard, ->(data) { data.key?(:player_advanced_stats) }, advanced_stats_transform)
            .>> t(:guard, ->(data) { data.key?(:player_stats) }, player_stats_transform)
        end

        def player_stats_transform
          fn = DefaultTransformer.new(:stats) >> t(:rename_keys, stats: :standard_stats)
          t(:map_value, :player_stats, fn) >> t(:rename_keys, player_stats: :stats)
        end

        def advanced_stats_transform
          KeyUnwrapper.new(:player_advanced_stats, :stats)
            .>> t(:rename_keys, stat: :advanced_stats)
            .>> t(:nest, :player_stats, [:advanced_stats])
        end
      end
    end
  end
end
