# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceTransformer < BaseTransform
      def initialize(resource)
        @resource = resource.to_sym
        @klass = class_for(@resource)
        @subresources = @klass.subresources
        @function = compose_function
        super
      end

      private

      def compose_function
        t(:guard, ->(data) { data.key?(@resource) }, t(:unwrap, @resource))
          .>> transform_subresources
          .>> Instantiator.new(@klass)
      end

      def transform_subresources
        transforms = @subresources.map { |subresource| Finder.find(@resource, subresource) }.compact
        transforms << Team::ManagerTransformer.new if resource_is?(:team)
        transforms.inject(&:>>)
      end

      def class_for(class_name)
        case class_name
        when :game
          YFantasy::Game
        when :league
          YFantasy::League
        when :player
          YFantasy::Player
        when :team
          YFantasy::Team
        else
          raise "Unexpected class name #{class_name} given"
        end
      end

      # TODO: I think this will be needed for nested primary resources (e.g., team > players)
      def is_primary?(resource)
        [:game, :league, :player, :team].include?(resource.to_sym)
      end

      def resource_is?(resource)
        @resource == resource
      end
    end
  end
end
