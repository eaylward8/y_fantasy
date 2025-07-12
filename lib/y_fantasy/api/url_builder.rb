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

      def initialize(resource, keys: [], game_codes: [], subresources: [], **options)
        @resource = resource.to_s
        @keys = Array(keys).map(&:to_s)
        @game_codes = Array(game_codes).map(&:to_s)
        @subresources = Array(subresources)
        @options = options
        @url = options[:scope_to_user] ? CURRENT_USER_URL.dup : BASE_URL.dup
      end

      def build
        validate_args!
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
        @url.concat("/", @resource, collection_params)
      end

      def collection_params
        if @resource == "games" && !@game_codes.empty?
          return ";game_codes=#{@game_codes.join(",")}"
        end

        return "" if @keys.compact.empty?

        ";#{singularize(@resource)}_keys=#{@keys.join(",")}"
      end

      def singular_resource?
        singularize(@resource) == @resource
      end

      def singularize(resource)
        YFantasy::Transformations::T.singularize(resource)
      end

      def validate_args!
        if !@game_codes.empty? && !@keys.empty?
          raise self.class::Error.new("Cannot build URL with both keys and game_codes")
        end

        if !@game_codes.empty? && @resource != "games"
          raise self.class::Error.new("`game_codes` can only be used with Games collection")
        end
      end

      class Error < StandardError
      end
    end
  end
end
