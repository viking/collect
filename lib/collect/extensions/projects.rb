module Collect
  module Extensions
    module Projects
      def self.registered(app)
        app.before %r{^(/admin)?/projects/(\d+)} do |admin, project_id|
          dataset = Role.filter(:project_id => project_id, :user_id => current_user.id)
          if admin
            dataset = dataset.filter(:is_admin => true)
          end
          @role = dataset.first

          if @role
            @project = @role.project
          else
            halt 403
          end
        end

        app.get '/projects' do
          @roles = current_user.roles
          erb :'projects/index'
        end

        app.get '/projects/:id' do
          erb :'projects/show'
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
          @forms = @project.forms
          erb :'projects/admin_show'
        end
      end
    end
  end
end
