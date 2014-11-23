set :application, 'mooc'
#set :repo_url, 'git@124.202.141.250:xuhong/mooc.git'
set :repo_url, 'git@10.10.31.46:pbl/pbl_base_service.git'

set :branch, ENV['BRANCH'] || "master"

#set :deploy_to, '/var/www/mooc'
set :deploy_to, "/home/deployer/pbl_base_service"

set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, false
set :rvm_ruby_version, 'jruby-1.7.13'
set :default_shell, '/bin/bash -l'
set :assets_roles, [:web, :app]
set :whenever_roles, :app
# set :sidekiq_options, -> { "-C #{current_path}/config/sidekiq.yml" }

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

#set :default_env, { path: "~/.rvm/rubies/jruby-1.7.8/bin/ruby:$PATH" }

#set :puma_state, "#{shared_path}/tmp/pids/puma.state"
#set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
#set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_bind, "tcp://0.0.0.0:9292"
#set :puma_conf, "#{shared_path}/puma.rb"
#set :puma_access_log, "#{shared_path}/log/puma_error.log"
#set :puma_error_log, "#{shared_path}/log/puma_access.log"
#set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [16, 48]
set :puma_workers, 0


set :keep_releases, 3

namespace :deploy do

  desc 'Restart application'
  task :restart do

  end

  task :print_path do
    on roles(:all) do |h|
      execute "echo $PATH"
    end
  end

  after :restart, :clear_cache do

  end

  #after :updated, :precompile do
  #  on roles(:all) do |h|
  #    execute "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  #  end
  #end

  after :finishing, 'deploy:cleanup'
end
