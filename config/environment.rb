# Load site-wide Constants / Settings
#require File.join( Rails.root.to_s, 'config','site_setting')
#Site.generate_CSS_files    # generate CSS files during start-up
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SampleApp::Application.initialize!
