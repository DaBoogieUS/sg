# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Sg::Application.initialize!

# production environment
ENV['RAILS_ENV'] ||= 'production'
