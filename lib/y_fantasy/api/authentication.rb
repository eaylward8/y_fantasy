# frozen_string_literal: true

require "base64"
require "json"
require "net/http"
require "uri"
require "mechanize"

module YFantasy
  module Api
    class Authentication
      CLIENT_ID = ENV["YAHOO_CLIENT_ID"]
      CLIENT_SECRET = ENV["YAHOO_CLIENT_SECRET"]
      YAHOO_USERNAME = ENV["YAHOO_USERNAME"]
      YAHOO_PASSWORD = ENV["YAHOO_PASSWORD"]

      REQUEST_AUTH_URL = "https://api.login.yahoo.com/oauth2/request_auth?client_id=#{CLIENT_ID}&redirect_uri=oob&response_type=code"
      GET_TOKEN_URL = "https://api.login.yahoo.com/oauth2/get_token"

      # NOTE: access token expires in 1 hour (3600 seconds)

      class << self
        attr_reader :access_token, :access_token_expires_at, :refresh_token

        def authenticate
          return true if access_token_valid?

          @refresh_token ? authenticate_with_refresh_token : authenticate_with_code
        end

        private

        # TODO: Use HTTPSuccess (2xx) and HTTPClientError (4xx) classes to handle responses

        def authenticate_with_refresh_token
          puts "auth with refresh token"
          # TODO: error handling
          response = post(GET_TOKEN_URL, post_data("refresh_token", refresh_token: refresh_token))
          body = JSON.parse(response.body)
          set_token_data(body["access_token"], body["expires_in"], body["refresh_token"])
          true
        end

        def authenticate_with_code
          puts "auth with code (mechanize)"
          code = get_auth_code
          # TODO: error handling
          response = post(GET_TOKEN_URL, post_data("authorization_code", code: code))
          body = JSON.parse(response.body)
          set_token_data(body["access_token"], body["expires_in"], body["refresh_token"])
          true
        end

        def get_auth_code
          # TODO: error handling, move this crap to a new class
          agent = Mechanize.new
          login_page1 = agent.get(REQUEST_AUTH_URL)
          username_form = login_page1.forms.first
          # Enter username
          username_form.username = YAHOO_USERNAME
          # Click "Next" button
          login_page2 = agent.submit(username_form, username_form.buttons.first)
          pw_form = login_page2.forms.first
          # Enter password
          pw_form.password = YAHOO_PASSWORD
          # Click "Verify password"
          auth_code_page = agent.submit(pw_form, pw_form.button("verifyPassword"))
          # Extract code
          # TODO: sometimes below line fails w/ undefined method [] for nil, add a retry?
          match = auth_code_page.uri.query.match(/code=(?<code>\w+)/)
          match[:code] if match
        end

        def post(url, data)
          Net::HTTP.post(URI(url), URI.encode_www_form(data), post_headers)
        end

        def post_headers
          {
            "Authorization" => "Basic #{basic_auth_token}",
            "Content-Type" => "application/x-www-form-urlencoded"
          }
        end

        def post_data(grant_type, refresh_token: nil, code: nil)
          {
            "grant_type" => grant_type,
            "redirect_uri" => "oob",
            "refresh_token" => refresh_token,
            "code" => code
          }
        end

        def post_options(grant_type, refresh_token: nil, code: nil)
          {
            body: {
              grant_type: grant_type,
              redirect_uri: "oob",
              refresh_token: refresh_token,
              code: code
            },
            headers: {
              Authorization: "Basic #{basic_auth_token}",
              "Content-Type": "application/x-www-form-urlencoded"
            }
          }
        end

        def basic_auth_token
          @basic_auth_token ||= Base64.strict_encode64("#{CLIENT_ID}:#{CLIENT_SECRET}")
        end

        def set_token_data(access_token, expires_in, refresh_token)
          @access_token = access_token
          @expires_in_seconds = expires_in.to_i
          @refresh_token = refresh_token
        end

        def access_token_valid?
          now = Time.now.to_i
          access_token && now < now + @expires_in_seconds
        end
      end
    end
  end
end
