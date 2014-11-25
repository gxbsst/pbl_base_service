source 'http://ruby.taobao.org'

gem 'rails', '4.1.7'
gem 'rails-api'
gem 'pg', platform: :ruby

gem 'activerecord-jdbcpostgresql-adapter', platforms: [:jruby]

gem 'versionist'

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
end

group :development do
 gem 'spring'
 gem "spring-commands-rspec"
 gem 'capistrano', '~> 3.0.1', :platforms => [:ruby, :jruby]
 gem 'capistrano-rails', '~> 1.1.0', :platforms => [:ruby, :jruby]
 gem 'capistrano3-puma', '~> 0.1.2', :platforms => [:ruby, :jruby]
 gem 'capistrano-rvm', :platforms => [:ruby, :jruby]
 gem 'capistrano-bundler', :platforms => [:ruby, :jruby]
 gem 'capistrano-sidekiq'
end

group :test do
  gem 'database_cleaner'
  gem 'json_spec'
end
# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# To use Jbuilder templates for JSON
gem 'jbuilder'

group :production do
  gem 'rack-cache', :require => 'rack/cache'
  gem 'puma'
end
