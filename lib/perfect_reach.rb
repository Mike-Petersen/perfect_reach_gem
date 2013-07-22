require 'active_support'
require "perfect_reach/version"
require "perfect_reach/api"
require "perfect_reach/api_error"
require "perfect_reach/api_request"
require "perfect_reach/configuration"
require "perfect_reach/contact"
require "perfect_reach/contact_list"

module PerfectReach
	def self.configure
		yield PerfectReach::Configuration
	end

	def self.config
		PerfectReach::Configuration
	end
end
