source 'http://ruby.taobao.org'

gem 'rails', '4.1.7'
gem 'rails-api'
gem 'pg', platform: :ruby
gem 'mongoid', "~> 4.0.0"
gem 'kaminari'
gem 'activerecord-jdbcpostgresql-adapter', platforms: [:jruby]
gem 'versionist'
gem 'acts-as-taggable-on', '~> 3.4'
gem 'state_machine', tag: 'v1.2.1', git: 'https://github.com/LiveTyping/state_machine.git'
gem 'closure_tree'
gem 'surrounded'
gem 'whenever', :require => false
gem 'sidekiq'
gem 'sidekiq-daemon', git: 'https://github.com/yabawock/sidekiq-daemon'
gem 'sidekiq-limit_fetch'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'thin', platforms: [:ruby]
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-sidekiq'
end

group :development, :release do
  gem 'seedbank'
end

group :test do
  gem 'mongoid-rspec'
  gem 'database_cleaner'
  gem 'json_spec'
  gem 'shoulda-matchers', require: false
  # gem 'rspec-sidekiq'
  gem 'email_spec'
end
# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# To use Jbuilder templates for JSON
gem 'jbuilder'

group :production do
  gem 'rack-cache', :require => 'rack/cache'
  gem 'puma'
end

gem "figaro"

gem 'sinatra', require: false