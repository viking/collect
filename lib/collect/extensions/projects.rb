module Collect
  module Extensions
    module Projects
      def self.registered(app)
        app.get '/projects' do
          @projects = current_user.projects
          erb :'projects/index'
        end

        app.get '/projects/new' do
          @project = Project.new
          erb :'projects/new'
        end

        app.post '/projects' do
          @project = Project.new(params['project'])
          if @project.save
            Role.create(:user_id => current_user.id, :project_id => @project.id, :is_admin => true)
            redirect "/projects/#{@project.id}"
          end
          erb :'projects/new'
        end

        app.get '/projects/:id' do
          @role = Role[:project_id => params['id'], :user_id => current_user.id]
          if @role
            @project = @role.project
            erb :'projects/show'
          else
            halt 403
          end
        end
      end
    end
  end
end
