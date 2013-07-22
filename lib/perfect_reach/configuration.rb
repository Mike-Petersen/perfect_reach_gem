require 'active_support/core_ext/module/attribute_accessors'

module PerfectReach
	module Configuration
		mattr_accessor :api_version
		mattr_accessor :api_key
		mattr_accessor :host
		mattr_accessor :port
		mattr_accessor :use_https

		@@api_version = 0.1
		@@use_https = true
	end
end
