# frozen_string_literal: true

module YFantasy
  module Api
    class UrlBuilder
      # NOTE: Could also make an id_params method and use it like `league_ids=`
      # Key example (game_id.l (for league).league_id): <league_key>79.l.31399</league_key>
      # ID example (last part of key) <league_id>31399</league_id>
      # valid urls:
      #   /games;game_keys=79/leagues;league_keys=79.l.31399
      #   /games;game_keys=79/leagues;league_ids=31399
      #   /game/79/leagues;league_keys=79.l.31399
      #   /game/79/leagues;league_ids=31399

      # invalid urls:
      #   /games;game_keys=79/league/31399
      #   /games;game_keys=79/league/79.l.31399
      #   /game/79/league/79.l.31399
      #   /game/79/league/31399

      BASE_URL = "https://fantasysports.yahooapis.com/fantasy/v2"
      CURRENT_USER_URL = "#{BASE_URL}/users;use_login=1"

      def initialize(resource, keys, subresources = [], scope_to_user: false)
        @resource = resource.to_s
        @keys = Array(keys).map(&:to_s)
        @subresources = Array(subresources)
        @url = scope_to_user ? CURRENT_USER_URL.dup : BASE_URL.dup
      end

      # TODO: will Set be helpful here?
      def build
        # raise some error if resource (and keys?) not set
        singular_resource? ? build_resource_url : build_collection_url
        return @url if @subresources.empty?

        # validate subresources here?
        # possible syntax: (or consider dry-validation)
        # SubresourceValidator.for(resource/resource, subresources).validate!
        url_with_subresources
      end

      private

      def url_with_subresources
        # start simple - no nested subs
        # TODO: clean this up
        subresources = @subresources.map do |sub|
          sub == :draft_results ? :draftresults : sub
        end
        out_params = ";out=#{subresources.join(",")}"
        @url.concat(out_params)
      end

      def build_resource_url
        # TODO: raise error if more than one key?
        @url.concat("/", @resource, "/", @keys.first)
      end

      def build_collection_url
        @url.concat("/", @resource, key_params)
      end

      def key_params
        return "" if @keys.compact.empty?

        ";#{singularize(@resource)}_keys=#{@keys.join(",")}"
      end

      def singular_resource?
        singularize(@resource) == @resource
      end

      def singularize(resource)
        YFantasy::Transformations::T.singularize(resource)
      end
    end
  end
end
