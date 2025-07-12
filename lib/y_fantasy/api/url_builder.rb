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

      def initialize(resource, keys, subresources = [], **options)
        @resource = resource.to_s
        @keys = Array(keys).map(&:to_s)
        @subresources = Array(subresources)
        @options = options
        @url = options[:scope_to_user] ? CURRENT_USER_URL.dup : BASE_URL.dup
      end

      def build
        singular_resource? ? build_resource_url : build_collection_url
        return @url if @subresources.empty?

        params = SubresourceParamBuilder.new(@subresources, **@options).build
        @url.concat(params)
      end

      private

      def build_resource_url
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
