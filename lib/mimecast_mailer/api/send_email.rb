module MimecastMailer
  module Api
    class SendEmail < Base
      def initialize(options = {})
        super

        @uri = '/api/email/send-email'
        @settings = options
      end

      def call(mail, base_path)
        response = post("#{base_path}#{@uri}", header, request_body(mail, base_path), {to_json: true})

        raise StandardError, "Can't send mail. #{error_response(response)}" if error?(response)

        response
      end

      private

      def header
        {
          "x-mc-date": x_mc_date,
          "x-mc-req-id": x_mc_req_id,
          "x-mc-app-id": @app_id,
          "Authorization": authorization,
          "Content-Type": 'application/json'
        }
      end

      def request_body(mail, base_path)
        {
          data: [
            {
              to: to(mail),
              subject: mail.subject.toutf8,
              **html_body(mail),
              **plain_body(mail),
              **attachments(mail, base_path)
            }
          ]
        }
      end

      def to(mail)
        Array(mail['to']).map do |email|
          {"emailAddress": email.to_s, "displayableName": email.to_s}
        end
      end

      def html_body(mail)
        return {} unless mail.html_part

        { htmlBody: {content: mail.html_part.body.to_s} }
      end

      def plain_body(mail)
        return {} unless mail.text_part

        { plainBody: {content: mail.text_part.body.to_s} }
      end

      def html_part(mail)
        return {} unless mail.html_part

        { htmlBody: {content: mail.html_part.body.to_s} }
      end

      def attachments(mail, base_path)
        return {} unless mail.attachments.any?

        attachments = mail.attachments.map do |attachment|
          file_upload_id = ::MimecastMailer::Api::SendFile.new(@settings).call(attachment.body.raw_source, base_path)

          { filename: attachment_filename(attachment), id: file_upload_id, size: attachment.body.raw_source.length }
        end

        { "attachments": attachments }
      end

      def attachment_filename(attachment)
        # Copied from https://github.com/rails/rails/blob/6bfc637659248df5d6719a86d2981b52662d9b50/activestorage/app/models/active_storage/filename.rb#L57
        attachment.filename.encode(
          Encoding::UTF_8, invalid: :replace, undef: :replace, replace: "�").strip.tr("\u{202E}%$|:;/\t\r\n\\", "-"
        )
      end
    end
  end
end