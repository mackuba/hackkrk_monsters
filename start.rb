require 'bundler/setup'
require 'gaminator'

$LOAD_PATH << File.expand_path('.')

require 'game'

Gaminator::Runner.new(Game, :rows => 25, :cols => 75).run
