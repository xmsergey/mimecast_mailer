module MimecastMailer
  class Railtie < Rails::Railtie
    initializer "mimecast_mailer.add_delivery_method" do
      ActiveSupport.on_load :action_mailer do
        ActionMailer::Base.add_delivery_method(:mimecast_mailer, MimecastMailer::DeliveryMethod)
      end
    end
  end
end