module Collect
  module Extensions
    module Projects
      def self.registered(app)
        app.get '/projects' do
          @projects = current_user.projects
          erb :'projects/index'
        end
      end
    end
  end
end
