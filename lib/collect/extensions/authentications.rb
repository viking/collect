module Collect
  module Extensions
    module Authentications
      def self.registered(app)
        if !app.settings.respond_to?(:provider)
          if app.production?
            raise "Please setup an OmniAuth provider!"
          else
            app.use OmniAuth::Strategies::Developer
            app.set :provider, :developer
          end
        end

        app.before %r{^(?!/auth)} do
          @current_user = session[:user_id] ? User[session[:user_id]] : nil
          if @current_user.nil?
            redirect "/auth/#{settings.provider}"
          end
        end

        app.get '/auth/:provider/callback' do
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
  end
end
