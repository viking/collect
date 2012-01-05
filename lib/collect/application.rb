module Collect
  class Application < Sinatra::Base
    enable :sessions
    set :root, Collect::Root.to_s

    get '/' do
      erb :index
    end
  end
end
