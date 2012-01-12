module Collect
  module Extensions
    module Forms
      def self.registered(app)
        app.get '/admin/projects/:project_id/forms/new' do
          @form = Form.new
          erb :'forms/admin_new'
        end
      end
    end
  end
end
