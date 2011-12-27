module Collect
  class Application < Sinatra::Base
    enable :sessions
    set :root, Collect::Root.to_s

    if !settings.respond_to?(:provider)
      if production?
        raise "Please setup an OmniAuth provider!"
      else
        use OmniAuth::Strategies::Developer
        set :provider, :developer
      end
    end

    before %r{^(?!/auth)} do
      @current_user = session[:user_id] ? User[session[:user_id]] : nil
      if @current_user.nil?
        redirect "/auth/#{settings.provider}"
      end
    end

    get '/' do
      erb :index
    end

    get '/auth/:provider/callback' do
      oa = request.env['omniauth.auth']
      auth = Authentication[:uid => oa[:uid], :provider => oa[:provider]]
      if auth
        session[:user_id] = auth.user_id
        redirect '/'
      else
        redirect '/auth/' + params[:provider]
      end
    end
  end
end
