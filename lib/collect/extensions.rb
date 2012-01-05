module Collect
  module Extensions
  end
end

path = Collect::Root + 'lib' + 'collect' + 'extensions'
require path + 'authentications'

Collect::Application.register(Collect::Extensions::Authentications)
