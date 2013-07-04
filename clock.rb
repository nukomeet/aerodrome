require 'clockwork'
require 'sidekiq'
require 'json'

require './app'

Dir["workers/*"].each { |f| load f }

every(5.seconds, Ping, { id: "ping" })
