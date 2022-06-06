require 'time'
require 'securerandom'
require 'openssl'
require 'base64'
require 'net/https'
require 'json'
require 'digest'

module MimecastMailer
  module Api
    class Base
      def initialize(options = {})
        @secret_key = options[:secret_key]
        @access_key = options[:access_key]
        @app_id = options[:app_id]
        @app_key = options[:app_key]
      end

      def authorization
        data_to_sign = "#{x_mc_date}:#{x_mc_req_id}:#{@uri}:#{@app_key}"
        hmac = Base64.encode64(OpenSSL::HMAC.digest('sha1', Base64.decode64(@secret_key), data_to_sign)).strip

        "MC #{@access_key}:#{hmac}"
      end

      def post(uri, header, body, options = {})
        uri = URI.parse(uri)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        req = Net::HTTP::Post.new(uri.path)

        header.each { |key, value| req[key.to_s] = value }
        req.body = options[:to_json] ? body.to_json : body
        https.request(req)
      end

      def body(response)
        JSON.parse(response.body)
      end

      def error_response(response)
        "Response body: #{response.body.to_s}. Response header: #{response.header.to_json}"
      end

      def error?(response)
        response.code != "200" || !((body(response) || {}).dig("fail") || []).empty?
      end

      def x_mc_date
        Time.now.httpdate
      end

      def x_mc_req_id
        @_x_mc_req_id ||= SecureRandom.uuid
      end

      def x_mc_arg(file_content)
        "{'data': [{'sha256': '#{sha256(file_content)}', 'fileSize': #{file_content.length}}]}"
      end

      def sha256(file_content)
        sha = Digest::SHA2.new
        sha << file_content
        sha.hexdigest
      end
    end
  end
end