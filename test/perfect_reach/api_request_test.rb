# encoding: utf-8

require 'minitest_helper'

describe PerfectReach::ApiRequest do

	describe "#request_path" do
		it "should return the path of the method" do
			PerfectReach::ApiRequest.new('method_name').send(:request_path).must_equal '/api/method_name?format=json'
		end

		it "should respect api_version" do
			PerfectReach.config.expects(:api_version).returns('0.2')
			PerfectReach::ApiRequest.new('method_name').send(:request).get_fields('X-Api-Version')[0].must_equal '0.2'
		end
	end

	describe "#request" do
		it "should return an Http request" do
			request = PerfectReach::ApiRequest.new('method_name', {}, 'Post')
			request.send(:request).must_be_kind_of(Net::HTTP::Post)

			request = PerfectReach::ApiRequest.new('method_name', {}, 'Get')
			request.send(:request).must_be_kind_of(Net::HTTP::Get)
		end
	end

	describe "#response" do
		it "should raise an ApiError if authentication fails" do
			request = PerfectReach::ApiRequest.new('method_name', {}, 'Get')
			lambda {
				request.response
			}.must_raise(PerfectReach::ApiError)
		end

		it "should return a Hash with response values if request is ok" do
			request = PerfectReach::ApiRequest.new('me', {}, 'Get')
			response = request.response
			response.must_be_kind_of(Hash)
			response['user']['email'].must_equal 'test@perfect-reach.com'
		end
	end
end
