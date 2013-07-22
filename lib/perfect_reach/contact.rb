require 'perfect_reach/api'

module PerfectReach
	class Contact < OpenStruct
		def infos(options = {})
			PerfectReach::Api.instance.get("contacts/#{(self.id || self.email)}", options)["contact"]
		end

		class << self
			def all(options = {})
				PerfectReach::Api.instance.get('contacts', options)["contacts"].map do |result_hash|
					self.new(result_hash)
				end
			end
		end
	end
end
