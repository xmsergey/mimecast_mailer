# Mimecast Mailer [![Gem Version](https://badge.fury.io/rb/mimecast_mailer.svg)](https://badge.fury.io/rb/mimecast_mailer)

Send mails using Mimecast API (https://integrations.mimecast.com/documentation/endpoint-reference/email/).

## Rails Setup

First add the gem to your environment and run the `bundle` command to install it.

```rb
gem "mimecast_mailer"
```

### Option 1

Set the delivery method in `config/environments/development.rb`

```rb
config.action_mailer.delivery_method = :mimecast_mailer
config.action_mailer.perform_deliveries = true
```

### Option 2

Create new mailer in your mailing directory (app/mailers/api_mailer.rb)

```rb
class ApiMailer < ApplicationMailer
  self.delivery_method = :mimecast_mailer #if ::Configuration.production?
end
```

Inherit your mails from ApiMailer instead of ApplicationMailer

### Configuration

```rb
MimecastMailer.configure do |config|
  config.secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=="
  config.access_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  config.app_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  config.app_key = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # Optional parameter. If it is skipped then gem send additional api request to determine 
  # correct host name (https://api.mimecast.com/api/discover-authentication)
  config.api_path = "https://us-api.mimecast.com"
end
```

## Development & Feedback

Questions or problems? Please use the [issue tracker](https://github.com/xmsergey/mimecast_mailer/issues). If you would like to contribute to this project then pull requests appreciated.
