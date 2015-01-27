require 'dotenv'

Dotenv.load

require 'sinatra'

require 'sinatra/activerecord'
require 'rack-flash'

require_relative "helpers/formatting"
require_relative "helpers/sessions"
require_relative "helpers/github"

require_relative "models/note"
require_relative "controllers/notes"
require_relative "controllers/authentication"

enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'MY_DEV_SECRET_4_NOTES'

use Rack::Flash


get '/' do
  erb :home
end
