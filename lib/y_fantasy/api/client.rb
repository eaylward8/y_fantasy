# frozen_string_literal: true

require "json"
require "net/http"
require "uri"
require "ox"

module YFantasy
  module Api
    class Client
      BASE_URL = "https://fantasysports.yahooapis.com/fantasy/v2"
      CURRENT_USER_URL = "#{BASE_URL}/users;use_login=1"

      def initialize
        YFantasy::Api::Authentication.authenticate
        @access_token = YFantasy::Api::Authentication.access_token

        puts @access_token # TODO: remove
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

      def get(resource, keys, subresources, scope_to_user: false)
        url = UrlBuilder.new(resource, keys, subresources, scope_to_user: scope_to_user).build
        puts "\n Client#get #{url} \n"
        response = Net::HTTP.get(URI(url), "Authorization" => "Bearer #{@access_token}")
        Ox.load(response, mode: :hash_no_attrs)
      end

      def reauthenticate
        # TODO - if request fails, reset access token ivars by calling auth again
      end
    end
  end
end
