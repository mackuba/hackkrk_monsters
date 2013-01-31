require 'bundler/setup'
require 'gaminator'
require 'debugger'

$LOAD_PATH << File.expand_path('.')

require 'game'

Gaminator::Runner.new(Game, :rows => 24, :cols => 80).run
