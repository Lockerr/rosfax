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
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}` && rails s -e production -p 3000  -d; else cd #{deploy_to}/current && rails s -e production  -p 3000 -d ; fi"
  end
  
  task :start do
    run "cd #{deploy_to}/current && rails s -e production -p 3000  -d"
  end
  
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  task :migrate do
    run "cd /home/perekup/rosfax/current && bundle exec rake db:migrate"
  end

  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ application/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
  
end