module Collect
  module Extensions
    module Projects
      def self.registered(app)
        app.before %r{^(/admin)?/projects/(\d+)} do |admin, project_id|
          dataset =
            if admin
              current_user.roles_dataset.admin
            else
              current_user.roles_with_active_projects_dataset
            end

          @role = dataset.filter(:project_id => project_id).first

          if @role
            @project = @role.project
          else
            halt 404
          end
        end

        app.get '/projects' do
          @roles = current_user.roles_with_active_projects
          mustache :'projects/index'
        end

        app.get '/projects/:id' do
          mustache :'projects/show'
        end

        app.get '/admin/projects/new' do
          @project = Project.new
          mustache :'admin/projects/new'
        end

        app.post '/admin/projects' do
          @project = Project.new(params['project'])
          if @project.save
            Role.create(:user_id => current_user.id, :project_id => @project.id, :is_admin => true)
            redirect "/admin/projects/#{@project.id}"
          end
          mustache :'admin/projects/new'
        end

        app.get '/admin/projects/:id' do
          @forms = @project.forms
          mustache :'admin/projects/show'
        end

        app.get '/admin/projects/:id/edit' do
          mustache :'admin/projects/edit'
        end

        app.post '/admin/projects/:id' do
          @project.set(params['project'])
          if @project.save
            redirect "/admin/projects/#{@project.id}"
          end
          mustache :'admin/projects/edit'
        end
      end
    end
    Application.register(Projects)
  end
end
