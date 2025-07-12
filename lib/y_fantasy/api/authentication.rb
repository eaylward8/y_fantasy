# frozen_string_literal: true

require "base64"
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
        # TODO: I don't think any of these readers are needed besides access_token. Maybe the error ones?
        attr_reader :access_token, :expires_at, :refresh_token, :error_type, :error_desc

        def authenticate
          return true if access_token_valid?

          refresh_token? ? authenticate_with_refresh_token : authenticate_with_code
        end

        def access_token_valid?
          !!access_token && !!expires_at && Time.now.to_i < expires_at
        end

        private

        def authenticate_with_refresh_token
          puts "auth with refresh token"
          response = post(GET_TOKEN_URL, post_data("refresh_token", refresh_token: refresh_token))
          handle_response(response)
        end

        def authenticate_with_code
          puts "auth with code (mechanize)"
          code = get_auth_code
          response = post(GET_TOKEN_URL, post_data("authorization_code", code: code))
          handle_response(response)
        end

        def handle_response(response)
          body = JSON.parse(response.body)

          case response
          when Net::HTTPSuccess
            set_token_data(body["access_token"], body["expires_in"], body["refresh_token"])
            clear_error_data
            true
          when Net::HTTPClientError, Net::HTTPServerError
            set_error_data(body["error"], body["error_description"])
            false
          end
        end

        def get_auth_code
          # TODO: error handling
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
          # match[:code] if match
          if match
            match[:code]
          else
            binding.pry
          end
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

        def basic_auth_token
          @basic_auth_token ||= Base64.strict_encode64("#{CLIENT_ID}:#{CLIENT_SECRET}")
        end

        def set_token_data(access_token, expires_in, refresh_token)
          @access_token = access_token
          @expires_at = Time.now.to_i + expires_in.to_i
          @refresh_token = refresh_token
        end

        def set_error_data(type, desc)
          @error_type = type
          @error_desc = desc
        end

        def clear_error_data
          @error_type = nil
          @error_desc = nil
        end

        def refresh_token?
          !!@refresh_token
        end
      end
    end
  end
end
