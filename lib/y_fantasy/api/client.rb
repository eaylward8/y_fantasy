# frozen_string_literal: true

require "json"
require "net/http"
require "uri"
require "ox"

module YFantasy
  module Api
    class Client
      @@retry = true

      def self.get(resource, keys: [], game_codes: [], subresources: [], **options)
        new.get(resource, keys: keys, game_codes: game_codes, subresources: subresources, **options)
      rescue Client::Error, Authentication::Error
        if @@retry
          @@retry = false
          retry
        end

        raise
      end

      def initialize
        authenticate
      end

      # NOTE: URL construction needs to be sophisticated enough to know when it should use "out" params vs
      # nested subresources.
      # E.g. /league/380.l.190823/teams/stats
      # this is how you get 1 league with all teams, and all stats for each team
      # teams is a subresource of league
      # stats is a subresource of teams
      #
      #
      # This fails because "stats" is not a subresource of league: /league/380.l.190823;out=teams/stats

      def get(resource, keys: [], game_codes: [], subresources: [], **options)
        refresh_access_token_if_needed

        url = UrlBuilder.new(resource, keys: keys, game_codes: game_codes, subresources: subresources, **options).build

        puts "\n Client#get #{url} \n" # TODO: remove

        response = Net::HTTP.get_response(URI(url), "Authorization" => "Bearer #{@access_token}")
        body = response.body

        case response
        when Net::HTTPSuccess
          Ox.load(body, mode: :hash_no_attrs).fetch(:fantasy_content)
        when Net::HTTPClientError
          error = Ox.load(body, mode: :hash_no_attrs)
          error_msg = error.dig(:"yahoo:error", :"yahoo:description") || error.dig(:error, :description)
          msg = "#{response.code}: #{error_msg}"
          raise YFantasy::Api::Client::Error.new(msg)
        else
          raise YFantasy::Api::Client::Error.new("An unknown error occurred")
        end
      end

      def authenticate
        if YFantasy::Api::Authentication.authenticate
          @access_token = YFantasy::Api::Authentication.access_token
          @refresh_token = YFantasy::Api::Authentication.refresh_token
        else
          @error_type = YFantasy::Api::Authentication.error_type
          @error_desc = YFantasy::Api::Authentication.error_desc
        end
      end

      def refresh_access_token_if_needed
        return if YFantasy::Api::Authentication.access_token_valid?

        authenticate
      end

      class Error < StandardError
        def initialize(msg = "")
          super
        end
      end
    end
  end
end
