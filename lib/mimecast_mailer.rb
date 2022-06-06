module MimecastMailer
  autoload :DeliveryMethod, "mimecast_mailer/delivery_method"
  autoload :Configuration, "mimecast_mailer/configuration"

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require "mimecast_mailer/railtie" if defined?(Rails::Railtie)
require "mimecast_mailer/api/base"
require "mimecast_mailer/api/send_file"
require "mimecast_mailer/api/send_email"
require "mimecast_mailer/api/discover_authentication"