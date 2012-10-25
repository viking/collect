module Collect
  module Extensions
    module Forms
      def self.registered(app)
        app.get '/admin/projects/:project_id/forms/new' do
          @form = Form.new(:project => @project)
          @form.sections_attributes = [{:name => 'main', :position => 0}]
          mustache :'admin/forms/new'
        end

        app.post '/admin/projects/:project_id/forms' do
          @form = Form.new(:project => @project)
        end
      end
    end
    Application.register(Forms)
  end
end
