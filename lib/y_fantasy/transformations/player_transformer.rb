# frozen_string_literal: true

module YFantasy
  module Transformations
    class PlayerTransformer < BaseTransform
      def initialize(nested: false)
        @nested = nested
        @function = compose_function
        super(nested)
      end

      private

      def compose_function
        t(:guard, ->(data) { data.key?(:player) }, t(:unwrap, :player))
          .>> transform_ownership_percentage
          .>> transform_stats
          .>> instantiate
      end

      def transform_ownership_percentage
        Player::OwnershipPercentageTransformer.new
      end

      def transform_stats
        Player::StatsTransformer.new
      end

      def instantiate
        @nested ? t(:no_op) : Instantiator.new(YFantasy::Player)
      end
    end
  end
end
