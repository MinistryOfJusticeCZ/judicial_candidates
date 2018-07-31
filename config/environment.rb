# Load the Rails application.
require_relative 'application'

ENV['EXECJS_RUNTIME'] ||= 'Node' unless Rails.env.test?

# Initialize the Rails application.
Rails.application.initialize!
