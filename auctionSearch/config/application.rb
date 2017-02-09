require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AuctionSearch
  class Application < Rails::Application
    #this can be changed for various time zones
	config.time_zone = 'Eastern Time (US & Canada)'

  end
end
