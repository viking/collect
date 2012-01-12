module Collect
  module Extensions
  end
end

path = Collect::Root + 'lib' + 'collect' + 'extensions'
require path + 'projects'
require path + 'forms'

Collect::Application.register(Collect::Extensions::Projects)
Collect::Application.register(Collect::Extensions::Forms)
