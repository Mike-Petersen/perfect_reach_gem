# encoding: utf-8
require 'minitest_helper'

describe PerfectReach::Api do
	describe "#method_missing" do
		it "should create an ApiRequest" do
			request = mock(:response => true)
			PerfectReach::ApiRequest.expects(:new).with(:user_infos, {:param1 => 1}, 'Post', PerfectReach.config.api_key).returns(request)
			PerfectReach::Api.instance.user_infos({:param1 => 1}, 'Post')
		end
	end
end
