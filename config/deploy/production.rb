set :rails_env, 'production'
set :deploy_to, "/home/deployer/production/pbl_base_service"

server '10.10.31.109',
       user: 'deployer',
       roles: %w{web app db whenever},
       ssh_options: {
           user: 'deployer', # overrides user setting above
           #keys: %w(/home/user_name/.ssh/id_rsa),
           #forward_agent: true,
           auth_methods: %w(password),
           password: '51448888'
       }

fetch(:default_env).merge!(rails_env: 'production', jruby_opts: '"-J-Xmx4096m --1.9"')