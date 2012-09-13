set :domain, "user@192.168.1.98"
set :deploy_to, "/home/perekup/rosfax"
set :rails_env, "development"
set :password, '12345trewq'

role :web, domain
role :app, domain
role :db, domain, :primary => true