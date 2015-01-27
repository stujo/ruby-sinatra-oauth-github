require 'rspec'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

require_relative '../app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  config.before do
    Note.destroy_all
  end

end

