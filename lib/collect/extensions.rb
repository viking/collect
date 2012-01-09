module Collect
  module Extensions
  end
end

path = Collect::Root + 'lib' + 'collect' + 'extensions'
require path + 'projects'

Collect::Application.register(Collect::Extensions::Projects)
