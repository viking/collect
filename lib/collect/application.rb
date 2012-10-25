module Collect
  class Application < Sinatra::Base
    register Mustache::Sinatra

    enable :sessions
    set :root, Collect::Root.to_s
    set :mustache, {
      :templates => (Collect::Root + 'templates').to_s,
      :views => (Collect::Root + 'lib' + 'collect' + 'views').to_s,
      :namespace => Collect
    }
    enable :reload_templates if development?

    if !settings.respond_to?(:provider)
      if production?
        raise "Please setup an OmniAuth provider!"
      else
        use OmniAuth::Strategies::Developer
        set :provider, :developer
      end
    end

    before %r{^(?!(?:/auth|/favicon\.ico))} do
      if current_user.nil?
        session[:return_to] ||= request.fullpath
        redirect "/auth/#{settings.provider}"
      end
    end

    helpers do
      def current_user
        @current_user ||= session[:user_id] ? User[session[:user_id]] : nil
      end
    end

    %w{get post}.each do |method|
      send(method, '/auth/:provider/callback') do
        oa = request.env['omniauth.auth']
        auth = Authentication[:uid => oa[:uid], :provider => oa[:provider]]
        if auth
          session[:user_id] = auth.user_id
          if session[:return_to]
            return_to = session.delete(:return_to)
            redirect return_to
          else
            redirect '/'
          end
        else
          redirect '/auth/' + params[:provider]
        end
      end
    end

    get '/' do
      mustache :index
    end
  end
end
