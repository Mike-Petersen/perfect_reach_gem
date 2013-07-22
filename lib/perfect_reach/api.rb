module PerfectReach
	class Api
		include Singleton

		def initialize(api_key = PerfectReach.config.api_key)
			@api_key = api_key
		end

		def method_missing(method_name, *args, &block)
			params, request_type = args
			request = ApiRequest.new(method_name, params, request_type, @api_key)
			request.response
		end

		def get(method_name, params)
			request = ApiRequest.new(method_name, params, 'get', @api_key)
			request.response
		end

		def post(method_name, params)
			request = ApiRequest.new(method_name, params, 'post', @api_key)
			request.response
		end

		def put(method_name, params)
			request = ApiRequest.new(method_name, params, 'put', @api_key)
			request.response
		end

		def delete(method_name, params)
			request = ApiRequest.new(method_name, params, 'delete', @api_key)
			request.response
		end
	end
end
