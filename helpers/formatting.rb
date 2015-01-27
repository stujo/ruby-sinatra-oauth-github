require 'rack/utils'

helpers do
  def h content
    Rack::Utils::escape_html content
  end  
end