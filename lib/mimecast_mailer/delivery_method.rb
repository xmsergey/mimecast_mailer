require 'time'
require 'securerandom'
require 'openssl'
require 'base64'
require 'net/https'
require 'json'

module MimecastMailer
  class DeliveryMethod
    class InvalidOption < StandardError; end

    attr_accessor :settings

    def initialize(options = {})
      options[:secret_key] = MimecastMailer.configuration.secret_key
      options[:access_key] = MimecastMailer.configuration.access_key
      options[:app_id] = MimecastMailer.configuration.app_id
      options[:app_key] = MimecastMailer.configuration.app_key
      options[:api_path] = MimecastMailer.configuration.api_path

      raise InvalidOption, "A secret_key is required when using the api Mailer delivery method" if options[:secret_key].nil?
      raise InvalidOption, "A access_key is required when using the api Mailer delivery method" if options[:access_key].nil?
      raise InvalidOption, "A app_id is required when using the api Mailer delivery method" if options[:app_id].nil?
      raise InvalidOption, "A app_key is required when using the api Mailer delivery method" if options[:app_key].nil?

      self.settings = options
    end

    def deliver!(mail)
      validate_mail!(mail)

      ::MimecastMailer::Api::SendEmail.new(settings).call(mail, api_path(mail))
    end

    private

    def validate_mail!(mail)
      if !mail.smtp_envelope_from || mail.smtp_envelope_from.empty?
        raise ArgumentError, "SMTP From address may not be blank"
      end

      if !mail.smtp_envelope_to || mail.smtp_envelope_to.empty?
        raise ArgumentError, "SMTP To address may not be blank"
      end
    end

    def api_path(mail)
      settings[:api_path] || ::MimecastMailer::Api::DiscoverAuthentication.new(settings).call(mail.smtp_envelope_from)
    end
  end
end