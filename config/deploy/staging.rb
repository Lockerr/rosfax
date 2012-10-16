set :domain, "user@192.168.1.98"
set :deploy_to, "/home/user/rosfax"
set :rails_env, "development"
set :password, 'ktghfpjhbq'

role :web, domain
role :app, domain
role :db, domain, :primary => true

set :unicorn_pid, "#{deploy_to}/shared/pids/server.pid"
set :rails_env, 'development'
set :deploy_via, 'copy'
set :scm, :git
set :repository, '.'


namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && rails s -p 3000 -e #{rails_env} -d ; fi"
  end
  task :start do
    run "cd /home/perekup/rosfax/current && rvm r328 do bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D "
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  task :migrate do
    run "cd /home/perekup/rosfax/current && bundle exec rake db:migrate"
  end
end