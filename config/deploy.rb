set :application, "crm"
set :repository,  "ssh://anton@192.168.1.71/home/anton/work/tradein/"
set :domain, 'user@192.168.1.98'
set :password, 'ktghfpjhbq'
set :deploy_to, '/home/user/tradein/'
set :rvm_ruby_string, 'ruby-1.9.2-p320@r322'
require "rvm/capistrano"

set :deploy_via, :copy

set :scm, :git
set :scm_passphrase, 'werwerw'
set :scm_password, 'werwerw'
set :scm_username, 'anton'
set :use_sudo, true

role :web, domain
role :app, domain
role :db,  domain, :primary => true

after 'update_code', 'bundle install'
namespace :deploy do
  task :start do
    run "cd #{deploy_to}current && bundle exec rails s -p 3003 -e development -d"
  end

  task :restart do
    run "if [ -f #{deploy_to}shared/pids/server.pid ]; then kill -9 `cat #{deploy_to}shared/pids/server.pid` && cd #{deploy_to}current && bundle exec rails s -p 3003 -e development -d; else cd #{deploy_to}/current && bundle exec rails s -p 3003 -e development -d; fi"
  end
end

