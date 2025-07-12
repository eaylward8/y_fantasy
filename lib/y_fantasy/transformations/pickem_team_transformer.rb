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
          .>> transform_manager
          .>> instantiate
      end

      def transform_manager
        Team::ManagerTransformer.new
      end

      def instantiate
        @nested ? t(:no_op) : Instantiator.new(YFantasy::PickemTeam)
      end
    end
  end
end
