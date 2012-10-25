module Collect
  module Extensions
  end
end

path = Collect::Root + 'lib' + 'collect' + 'extensions'
require path + 'projects'
require path + 'forms'
