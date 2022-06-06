module MimecastMailer
  module Api
    class DiscoverAuthentication < Base
      def call(from_email)
        return default_api_path unless from_email

        response = post('https://api.mimecast.com/api/login/discover-authentication', header, request_body(from_email), {to_json: true})

        raise StandardError, "Can't request host name. Please try to set `config.api_path = 'https://us-api.mimecast.com'` configuration value. #{error_response(response)}" if error?(response)

        body(response).dig("data", 0, "region", "api") || default_api_path
      end

      private

      def default_api_path
        'https://us-api.mimecast.com'
      end

      def header
        {
          "x-mc-date": x_mc_date,
          "x-mc-req-id": x_mc_req_id,
          "x-mc-app-id": @app_id,
          "Content-Type": 'application/json'
        }
      end

      def request_body(email)
        { data: [ { "emailAddress": email } ] }
      end
    end
  end
end
