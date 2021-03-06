# encoding: utf-8
require 'active_support'

module PerfectReach
	class ApiError < StandardError
		def initialize(code, res, request, request_path, params)
			# code is ugly, output is pretty
			error_text = res['errors'].present? ? [(res['errors'] || [])].flatten.map {|param, text| [param, text].map(&:to_s).reject(&:blank?).join(': ')}.join("\n") : res.inspect

			super("error #{code} while sending #{request.inspect} to #{request_path} with #{params.inspect}\n\n" +
						error_text +
						"\n\nPlease see http://api.perfect-reach.com for more informations on error numbers.\n\n"
			)
		end
	end
end
