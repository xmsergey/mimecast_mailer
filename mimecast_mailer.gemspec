Gem::Specification.new do |s|
  s.name         = 'mimecast_mailer'
  s.version      = '0.0.3'
  s.summary      = "Send mail using Mimecast API."
  s.description  = "When mail is sent from your application, Mimecast Mailer will send mail using Mimecast API (https://integrations.mimecast.com/documentation/endpoint-reference/email/)."
  s.author       = "Sergey Mazur"
  s.email        = 'sergey@gmail.com'
  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  s.require_path = "lib"
  s.homepage     = 'https://github.com/xmsergey/mimecast_mailer'
  s.license      = 'MIT'
end
