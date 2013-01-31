require 'bundler/setup'
require 'gaminator'
require 'debugger'

$LOAD_PATH << File.expand_path('.')

require 'game'

Gaminator::Runner.new(Game, :rows => 20, :cols => 50).run
