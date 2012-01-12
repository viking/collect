module Collect
  module Extensions
    module Projects
      def self.registered(app)
        app.get '/projects' do
          @roles = current_user.roles
          erb :'projects/index'
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

        app.get '/admin/projects/new' do
          @project = Project.new
          erb :'projects/admin_new'
        end

        app.post '/admin/projects' do
          @project = Project.new(params['project'])
          if @project.save
            Role.create(:user_id => current_user.id, :project_id => @project.id, :is_admin => true)
            redirect "/admin/projects/#{@project.id}"
          end
          erb :'projects/admin_new'
        end

        app.get '/admin/projects/:id' do
          @role = Role[:project_id => params['id'], :user_id => current_user.id, :is_admin => true]
          if @role
            @project = @role.project
            erb :'projects/admin_show'
          else
            halt 403
          end
        end
      end
    end
  end
end
