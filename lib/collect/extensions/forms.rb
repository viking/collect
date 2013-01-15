module Collect
  module Extensions
    module Forms
      def self.registered(app)
        app.before %r{^(/admin)?/projects/\d+/forms/(\d+)} do |admin, form_id|
          @form = @project.forms_dataset[:id => form_id]
          if @form.nil?
            halt 404
          end
        end

        # Admin
        #
        app.get '/admin/projects/:project_id/forms/new' do
          @form = Form.new(:project => @project)
          @form.sections_attributes = [{:name => 'main', :position => 0}]
          mustache :'admin/forms/new'
        end

        app.get '/admin/projects/:project_id/forms/:id/edit' do
          mustache :'admin/forms/edit'
        end

        app.get '/admin/projects/:project_id/forms/:id' do
          mustache :'admin/forms/show'
        end

        app.post '/admin/projects/:project_id/forms' do
          @form = Form.new(params[:form].merge(:project => @project))
          if @form.save
            redirect "/admin/projects/#{@project.id}"
          end
          mustache :'admin/forms/new'
        end

        app.post '/admin/projects/:project_id/forms/:id' do
          @form.set(params[:form])
          if @form.save
            redirect "/admin/projects/#{@project.id}"
          end
          mustache :'admin/forms/edit'
        end

        app.post '/admin/projects/:project_id/forms/:id/publish' do
          begin
            @form.publish!
          rescue FormAlreadyPublishedException
          end

          redirect "/admin/projects/#{@project.id}"
        end

        # Non-admin
        #
        app.get '/projects/:project_id/forms/:id' do
          mustache :'forms/show'
        end
      end
    end
    Application.register(Forms)
  end
end
