require 'capistrano/ext/multistage'
require "rvm/capistrano"





require 'capistrano_colors'

set :application, "rosfax"

require 'capistrano-unicorn'

capistrano_color_matchers = [
 { :match => /command finished/,       :color => :hide,      :prio => 10 },
 { :match => /executing command/,      :color => :blue,      :prio => 10, :attribute => :underscore },
 { :match => /^transaction: commit$/,  :color => :magenta,   :prio => 10, :attribute => :blink },
 { :match => /git/,                    :color => :white,     :prio => 20, :attribute => :reverse },
]

colorize( capistrano_color_matchers )


set :default_stage, 'staging'



set :use_sudo, false
set :rvm_type, :user

set :backup_dir, "#{deploy_to}/shared"

after 'deploy:restart', 'unicorn:reload' # application IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # application preloaded

after 'deploy:update_code', :roles => :application do
  run "cd #{current_release} ; bundle install"
  %w{database config}.each do |yaml_name|
    run "rm -f #{current_release}/config/#{yaml_name}.yml"
    run "ln -s #{deploy_to}/shared/config/#{yaml_name}.yml #{current_release}/config/#{yaml_name}.yml"
  end


end

task :backup, :roles => :db, :only => {:primary => true} do
  filename = "#{backup_dir}/#{application}.dump.#{Time.now.to_f}.sql.bz2"
  text = capture "cat #{deploy_to}/current/config/database.yml"
  yaml = YAML::load(text)

  on_rollback { run "rm #{filename}" }
  run "mysqldump -u #{yaml['production']['username']} -p #{yaml['production']['database']} | bzip2 -c > #{filename}" do |ch, stream, out|
    ch.send_data "#{yaml['production']['password']}\n" if out =~ /^Enter password:/
  end
end



        require './config/boot'
        require 'airbrake/capistrano'
desc "tail production log files"
task :logs, :roles => :app do
  trap("INT") { puts 'Interupted'; exit 0; }
  run "tail -f #{deploy_to}/shared/log/production.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end