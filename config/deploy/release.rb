set :rails_env, 'release'
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
## unless any hosts have the primary property set.
#role :app, %w{124.205.151.249}
#role :web, %w{124.205.151.249}
#role :db,  %w{124.205.151.249}q

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
#server '172.172.172.199', user: 'root', roles: %w{web app whenever db}
#server '172.172.172.120', user: 'deployer', roles: %w{web app whenever db}
#server '124.205.151.252', user: 'edu', roles: %w{web app}

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    #keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
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

fetch(:default_env).merge!(rails_env: 'release', jruby_opts: '"-J-Xmx4096m --1.9"')