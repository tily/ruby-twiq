require 'rubygems'
require 'sequel'
require 'oauth/cli/twitter'

require 'twiq/statuses'
require 'twiq/commands'

module Twiq
  class Error < StandardError; end
end

