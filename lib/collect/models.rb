# Some model-wide configuration
Sequel::Model.plugin :validation_helpers

path = Collect::Root + 'lib' + 'collect' + 'models'
require path + 'project'
require path + 'form'
require path + 'section'
require path + 'question'
