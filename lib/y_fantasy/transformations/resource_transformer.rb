# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceTransformer < BaseTransform
      def_delegators :@klass, :primary_subresources, :dependent_subresources

      def initialize(resource)
        @resource = resource.to_sym
        @klass = class_for(@resource)
        puts @klass
        @function = compose_function
        super
      end

      private

      def compose_function
        t(:guard, ->(data) { data.key?(@resource) }, t(:unwrap, @resource))
          .>> transform_subresources
          .>> Instantiator.new(@klass)
      end

      # TODO: extract into class
      def transform_subresources
        transforms = primary_subresource_transforms | dependent_subresource_transforms
        transforms << Team::ManagerTransformer.new if resource_is?(:team)
        transforms << DefaultTransformer.new(:stat_winners) if resource_is?(:matchup)
        transforms.inject(&:>>)
      end

      def primary_subresource_transforms
        primary_subresources.map { |subresource| CollectionTransformer.new(subresource, return_array: false) }.compact
      end

      def dependent_subresource_transforms
        dependent_subresources.map { |subresource| Finder.find(@resource, subresource) }.compact
      end

      def class_for(class_name)
        case class_name
        when :game
          YFantasy::Game
        when :league
          YFantasy::League
        when :matchup
          YFantasy::Matchup
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
