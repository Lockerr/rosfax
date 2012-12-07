load 'deploy/assets'

set :domain, "user@192.168.1.98"
set :deploy_to, "/home/user/rosfax"
set :rails_env, "development"
set :password, 'ktghfpjhbq'


role :web, domain
role :app, domain
role :db, domain, :primary => true

set :unicorn_pid, "#{deploy_to}/shared/pids/server.pid"
set :rails_env, 'development'
set :deploy_via, :copy
set :scm, :git
set :branch, :new_layout
set :repository, 'anton@192.168.1.71:work/tradein'


namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}` && rails s -p 3000 -e production -d; else cd #{deploy_to}/current && rails s -e production -p 3000 -d ; fi"
  end
  
  task :start do
    run "cd #{deploy_to}/current && rails s -p 3000 -e production -d"
  end
  
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  task :migrate do
    run "cd /home/perekup/rosfax/current && bundle exec rake db:migrate"
  end
end