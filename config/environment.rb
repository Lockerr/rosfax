# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tradein::Application.initialize!

config.after_initialize do
  Delayed::Job.scaler = :null
end