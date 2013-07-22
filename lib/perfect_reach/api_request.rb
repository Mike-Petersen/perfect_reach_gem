# encoding: utf-8
require 'active_support/core_ext/string'
require 'net/http'
require "net/https"
require 'json'
require 'cgi'

module PerfectReach
	class ApiRequest
		def initialize(method_name, params = {}, request_type = nil, auth_token = PerfectReach.config.api_key, host = PerfectReach.config.host, port = PerfectReach.config.port)
			@method_name = method_name.to_s
			@params = (params || {}).merge(:format => 'json')
			@request_type = (request_type || guess_request_type).camelize
			@auth_token = auth_token
			@host = host
			@port = port
		end

		def response
			@response ||= begin
				http = Net::HTTP.new(@host, @port)
				http.use_ssl = PerfectReach.config.use_https
				res = http.request(request)

				case res
					when Net::HTTPSuccess
						JSON.parse(res.body || '{}')
					when Net::HTTPNotModified
						{"status" => "not_modified"}
					else
						raise ApiError.new(res.code, JSON.parse(res.body.presence || '{}'), request, request_path, @params)
				end
			end
		end

		private
		def request
			@request ||= begin
				req = "Net::HTTP::#{@request_type}".constantize.new(request_path)
				Net::HTTP::Get
				req.add_field 'Authorization', "Token token=\"#{@auth_token}\""
				req.add_field 'X-Api-Version', PerfectReach.config.api_version
				req.set_form_data(@params)
				req
			end
		end

		def request_path
			@request_path ||= begin
				path = "/api/#{@method_name}"
				if @request_type == 'Get'
					path << '?' + @params.collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')
				end
				path
			end
		end

		def guess_request_type
			if @method_name =~ /(?:Create|Add|Remove|Delete|Update)(?:[A-Z]|$)/
				'Post'
			else
				'Get'
			end
		end
	end
end
