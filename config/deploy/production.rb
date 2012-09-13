puts "\n\e[0;31m"
puts "######################################################################" 
puts "#                                                                    #"
puts "#        Are you REALLY sure you want to deploy to production?       #"
puts "#                     Enter y/N + enter to continue                  #"
puts "#                                                                    #"
puts "######################################################################\e[0m\n" 

proceed = STDIN.gets[0..0] rescue nil 
exit unless proceed == 'y' || proceed == 'Y' 

set :domain, "perekup@perekup.net"
set :deploy_to, "/home/perekup/rosfax"
set :rails_env, "production"
set :password, '12345trewq'

role :web, domain
role :app, domain
role :db, domain, :primary => true

namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && rvm r328 do bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D ; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && rvm r328 do bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D "
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  task :migrate do
    run "cd #{deploy_to}/current && bundle exec rake db:migrate"
  end
end
