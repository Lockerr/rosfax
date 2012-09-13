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