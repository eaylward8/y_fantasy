# frozen_string_literal: true

require "base64"
require "net/http"
require "uri"
require "mechanize"
require "timeout"

module YFantasy
  module Api
    class Authentication
      YAHOO_CLIENT_ID = YFantasy.config.yahoo_client_id
      YAHOO_CLIENT_SECRET = YFantasy.config.yahoo_client_secret
      YAHOO_USERNAME = YFantasy.config.yahoo_username
      YAHOO_PASSWORD = YFantasy.config.yahoo_password

      REQUEST_AUTH_URL = "https://api.login.yahoo.com/oauth2/request_auth?client_id=#{YAHOO_CLIENT_ID}&redirect_uri=oob&response_type=code"
      GET_TOKEN_URL = "https://api.login.yahoo.com/oauth2/get_token"

      MSG_SEPARATOR = "#" * 50

      # NOTE: access token expires in 1 hour (3600 seconds)

      class << self
        # TODO: I don't think any of these readers are needed besides access_token. Maybe the error ones?
        attr_reader :access_token, :expires_at, :refresh_token, :error_type, :error_desc

        def authenticate
          return true if access_token_valid?

          if YFantasy.config.yahoo_refresh_token
            @refresh_token = YFantasy.config.yahoo_refresh_token
          end

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
          puts "auth with code"
          code = YFantasy.config.automate_login ? get_auth_code_automated : get_auth_code_manual
          response = post(GET_TOKEN_URL, post_data("authorization_code", code: code))
          handle_response(response, print_tokens: !YFantasy.config.automate_login)
        end

        def handle_response(response, print_tokens: false)
          body = JSON.parse(response.body)

          case response
          when Net::HTTPSuccess
            display_token_message(body) if print_tokens # Display token data to user after manual login
            set_token_data(body["access_token"], body["expires_in"], body["refresh_token"])
            clear_error_data
            true
          when Net::HTTPClientError, Net::HTTPServerError
            set_error_data(body["error"], body["error_description"])
            false
          end
        end

        def display_token_message(body)
          puts "\nAccess token: #{body["access_token"]}"
          puts "\nAccess token expires in: #{body["expires_in"]} seconds"
          puts "\nRefresh token: #{body["refresh_token"]}"
          puts "\nThe refresh token is long-lived and can be used to re-authenticate without the need for credentials."
          puts "Store it as an ENV variable called YAHOO_REFRESH_TOKEN or save it to a database."
          puts "Then, in your application, set YFantasy.config.yahoo_refresh_token = <your_refresh_token>"
          puts "If the yahoo_refresh_token config is set, YFantasy will use it to obtain a new access token when needed."
          puts "\nRead more about the Yahoo OAuth 2.0 Flow: https://developer.yahoo.com/oauth2/guide/flows_authcode/\n\n"
          puts MSG_SEPARATOR
          puts "#      YFantasy Manual Auth Code Flow - END      #"
          puts MSG_SEPARATOR
        end

        def get_auth_code_manual
          return if YFantasy.config.automate_login

          puts MSG_SEPARATOR
          puts "#     YFantasy Manual Auth Code Flow - START     #"
          puts MSG_SEPARATOR
          puts "\nGo to this URL and log into your Yahoo Account:"
          puts REQUEST_AUTH_URL
          puts "\nAfter logging in, copy and paste the code here:"
          Timeout.timeout(YFantasy.config.manual_login_timeout_seconds) do
            code = $stdin.gets.chomp
            puts "\nReceived code: #{code}. Attempting to retrieve access token and refresh token...\n"
            code
          end
        end

        # :nocov:
        def get_auth_code_automated
          return if YFantasy.config.automate_login == false

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
          return match[:code] if match

          raise Error.new("Failed to extract auth code")
        end
        # :nocov:

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
          @basic_auth_token ||= Base64.strict_encode64("#{YAHOO_CLIENT_ID}:#{YAHOO_CLIENT_SECRET}")
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
          @refresh_token && @refresh_token.length > 0
        end
      end

      class Error < StandardError
      end
    end
  end
end
