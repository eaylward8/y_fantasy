# frozen_string_literal: true

require "json"
require "net/http"
require "uri"
require "ox"

module YFantasy
  module Api
    class Client
      def self.get(resource, keys, subresources = [], scope_to_user: false)
        new.get(resource, keys, subresources, scope_to_user: scope_to_user)
      end

      def initialize
        YFantasy::Api::Authentication.authenticate
        @access_token = YFantasy::Api::Authentication.access_token
        @refresh_token = YFantasy::Api::Authentication.refresh_token

        puts @access_token # TODO: remove
        puts @refresh_token
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

      def get(resource, keys, subresources = [], scope_to_user: false)
        url = UrlBuilder.new(resource, keys, subresources, scope_to_user: scope_to_user).build
        puts "\n Client#get #{url} \n"
        response = Net::HTTP.get_response(URI(url), "Authorization" => "Bearer #{@access_token}")
        body = response.body

        case response
        when Net::HTTPSuccess
          Ox.load(body, mode: :hash_no_attrs).fetch(:fantasy_content)
        when Net::HTTPClientError
          error = Ox.load(body, mode: :hash_no_attrs)
          error_msg = error.dig(:"yahoo:error", :"yahoo:description")
          msg = "#{response.code}: #{error_msg}"
          raise msg
        end
      end

      def reauthenticate
        # TODO - if request fails, reset access token ivars by calling auth again
      end
    end
  end
end
