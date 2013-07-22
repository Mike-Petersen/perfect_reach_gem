require 'perfect_reach/api'
require 'perfect_reach/contact'

module PerfectReach
	class ContactList < OpenStruct
		def update(options = {})
			PerfectReach::Api.instance.put("contact_lists/#{self.id}", options)["status"]
		end

		def add_contacts(contacts, options={})
			throw 'Contacts must be an Array' unless contacts.is_a? Array
			contact_data = []
			contacts.each do |p|
				contact_data << (p.is_a?(PerfectReach::Contact) ? {email: p.email.to_s, name: p.name.to_s} : p)
			end
			PerfectReach::Api.instance.post("contact_lists/#{self.id}/add_contacts", options.reverse_merge(:contacts => contacts.to_json))["status"]
		end

		def unsubscribe_contact(*params)
			options = params.last.is_a?(Hash) ? params.pop : {}
			contact = params.map { |p| p.is_a?(PerfectReach::Contact) ? p.email.to_s : p.to_s }.reject(&:blank?).first
			PerfectReach::Api.instance.post("contact_lists/#{self.id}/unsubscribe_contact", options.reverse_merge(:contact => contact))["status"]
		end

		def remove_contacts(contacts, options={})
			throw 'Contacts must be an Array' unless contacts.is_a? Array
			contact_data = []
			contacts.each do |p|
				contact_data << (p.is_a?(PerfectReach::Contact) ? {email: p.email.to_s, name: p.name.to_s} : p)
			end
			PerfectReach::Api.instance.delete("contact_lists/#{self.id}/remove_contacts", options.reverse_merge(:contacts => contacts.to_json))["status"]
		end

		def contacts(options = {})
			PerfectReach::Api.instance.get("contact_lists/#{self.id}/contacts", options)["contacts"].map do |contact|
				PerfectReach::Contact.new(contact)
			end
		end

		def email(options = {})
			PerfectReach::Api.instance.get("contact_lists/#{self.id}/email", options)["email"]
		end

		def statistics(options = {})
			PerfectReach::Api.instance.get("contact_lists/#{self.id}/statistics", options)["statistics"]
		end

		def delete(options = {})
			PerfectReach::Api.instance.delete("contact_lists/#{self.id}", options)["status"]
		end

		class << self
			def create(options = {})
				data = PerfectReach::Api.instance.post('contact_lists', options)
				throw data['error_msg'] unless 'ok'.eql? data['status']
				self.new(options.merge(:id => data["id"].to_s))
			end

			def all(options = {})
				(PerfectReach::Api.instance.get('contact_lists', options)["contact_lists"] || []).map do |result_hash|
					self.new(result_hash)
				end
			end
		end
	end
end
