puts "\n\e[0;31m"
puts "######################################################################" 
puts "#                                                                    #"
puts "#        Are you REALLY sure you want to deploy to production?       #"
puts "#                     Enter y/N + enter to continue                  #"
puts "#                                                                    #"
puts "######################################################################\e[0m\n" 

load 'deploy/assets'

proceed = STDIN.gets[0..0] rescue nil 
exit unless proceed == 'y' || proceed == 'Y' 

set :domain, "perekup@perekup.net"
set :deploy_to, "/home/perekup/rosfax"
set :rails_env, "production"
set :password, '12345trewq'
set :rvm_ruby_string, 'r328'
set :deploy_via, :remote_cache
set :scm, :git
set :repository, "git@github.com:Lockerr/tradein.git"
set :branch, "new_layout"

role :web, domain
role :app, domain
role :db, domain, :primary => true

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

namespace :deploy do
  

  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd /home/perekup/rosfax/current && rvm r328 do bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D ; fi"
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
  

  # namespace :assets do
  #   task :precompile, :roles => :web, :except => { :no_release => true } do
  #     from = source.next_revision(current_revision)
  #     if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
  #       run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
  #     else
  #       logger.info "Skipping asset pre-compilation because there were no asset changes"
  #     end
  #   end
  # end

end

 