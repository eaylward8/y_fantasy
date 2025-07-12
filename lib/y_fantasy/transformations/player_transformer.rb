# frozen_string_literal: true

module YFantasy
  module Transformations
    class PlayerTransformer < BaseTransform
      def initialize
        @function = compose_function
        super
      end

      private

      def compose_function
        t(:guard, ->(data) { data.key?(:player) }, t(:unwrap, :player))
          .>> transform_ownership_percentage
          .>> transform_stats
          .>> Instantiator.new(YFantasy::Player)
      end

      def transform_ownership_percentage
        Player::OwnershipPercentageTransformer.new
      end

      def transform_stats
        Player::StatsTransformer.new
      end
    end
  end
end
