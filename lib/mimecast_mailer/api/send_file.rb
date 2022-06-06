module MimecastMailer
  module Api
    class SendFile < Base
      def initialize(options = {})
        super

        @uri = '/api/file/file-upload'
      end

      def call(file_content, base_path)
        response = post("#{base_path}#{@uri}", header(file_content), file_content)

        raise StandardError, "Can't send file. #{error_response(response)}" if error?(response)

        body(response)["id"]
      end

      private

      def header(file_content)
        {
          "x-mc-date": x_mc_date,
          "x-mc-req-id": x_mc_req_id,
          "x-mc-app-id": @app_id,
          "Authorization": authorization,
          "Content-Type": 'application/octet-stream',
          "x-mc-arg": x_mc_arg(file_content)
        }
      end
    end
  end
end