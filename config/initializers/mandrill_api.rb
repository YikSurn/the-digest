require 'rubygems'
require 'excon'

Excon.defaults[:ssl_verify_peer] = false
