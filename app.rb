require 'dotenv'

Dotenv.load

require 'sinatra'

require 'sinatra/activerecord'

require_relative "helpers/formatting"
require_relative "helpers/sessions"

require_relative "models/note"
require_relative "controllers/notes"
require_relative "controllers/authentication"

enable :sessions
set :session_secret, ENV['SESSION_SECRET'] || 'MY_DEV_SECRET_4_NOTES'

get '/' do
  erb :home
end
