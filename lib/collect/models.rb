# Some model-wide configuration
Sequel::Model.plugin :validation_helpers
Sequel::Model.raise_on_save_failure = false

path = Collect::Root + 'lib' + 'collect' + 'models'
require path + 'user'
require path + 'authentication'
require path + 'project'
require path + 'form'
require path + 'section'
require path + 'question'
require path + 'role'
