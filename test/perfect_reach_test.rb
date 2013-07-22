require 'minitest_helper'

describe PerfectReach do
	describe "#configure" do
		it "should permit to set api keys and remember them" do
			PerfectReach.configure do |config|
				config.api_key = 'sad786523'
				config.host = 'test.perfect-reach.com'
				config.port = '1324'
			end

			PerfectReach.config.api_key.must_equal 'sad786523'
			PerfectReach.config.host.must_equal 'test.perfect-reach.com'
			PerfectReach.config.port.must_equal '1324'
		end
	end
end
