require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'rspec-html-matchers'


ENV['RACK_ENV'] = 'test'

require_relative '../app'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include RSpec::HtmlMatchers

  def app
    Sinatra::Application
  end

  config.before do
    Note.destroy_all
  end

end

