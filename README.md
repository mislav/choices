Choices for Rails
=================

Easy-peasy external settings for your Rails app.

~~~ rb
# Gemfile
gem 'choices'
~~~

In your app initializer block:

~~~rb
config.from_hash {key: 'value', ...}

~~~

This will dynamically load the given Hash into your `Rails.configuration` and can be accessed using `Rails.configuration.key => 'value'`. Given Hash can be nested to any levels, but, you should be able to retrieve value using "." notaton.

~~~
Example:
  config.from_hash {key: {key: {key: 'value'}}}
  can be accessed using Rails.configuration.key.key.key => 'value'
~~~

This method is useful when you want to store values of settings.yml in a store and retrieve these values during bootup and make them available to your Rails stack through `Rails.configuration`.


#####Or


~~~ rb
config.from_file 'settings.yml'

~~~

This will read configuration from "config/settings.yml" and, additionally,
"settings.local.yml" if it exists. You should check the main file into version
control, but not the ".local" file which is to be used for per-machine
configuration: tweaks in development or private keys in production, for example.

~~~
# .gitignore
config/settings.local.yml
~~~

#####Or


~~~ rb
config.from_files [Pathname.new("settings.yml"), Pathname.new("settings.patch.yml")]

~~~

This will read configuration from "config/settings.yml" and, additionally,
"settings.local.yml" if it exists, and merges values from settings.patch.yml. If you want to maintain a default settings in the application and want to inject any additional settings you can add them in settings.patch.yml. You should check the main file into version
control, but not the ".patch" file which is to be used for per-machine
configuration: tweaks in development or private keys in production, for example.

~~~
# .gitignore
config/settings.patch.yml
~~~

Configuration files can contain ERB; this is useful for reading in dynamic
config such as from environment variables:

~~~ yaml
# settings.yml
defaults: &defaults
  secret_token: <%= ENV['COOKIE_SECRET'] %>
  heroku: <%= !!ENV['HEROKU_TYPE'] %>
  mongodb:
    uri: <%= ENV['MONGOHQ_URL'] %>

development:
  <<: *defaults

test: &testing
  <<: *defaults
  secret_token: <%= "banana" * 5 %>
  mongodb:
    database: myapp_test

cucumber:
  <<: *testing
~~~

The ".local" file can contain overrides for your development environment:

~~~ yaml
# settings.local.yml
development:
  mongodb:
    database: myapp_dev
~~~

Finally, the config keys can be read in your app as such:

~~~ rb
Rails.configuration.heroku              #=> false
Rails.configuration.mongodb.database    #=> "myapp_dev"
~~~
