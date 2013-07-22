require 'minitest_helper'

describe PerfectReach::Contact do
	it 'has an integration suite, tested directly against PerfectReach service' do
		# init
		PerfectReach::ContactList.all.each do |list|
			list.delete
		end
		list = PerfectReach::ContactList.create(:name => 'My PerfectReach list', language: 'en')
		list.add_contacts([{email: "c1@contacts.com"}])

		# PerfectReach::Contact.all
		contacts = PerfectReach::Contact.all
		contacts.wont_be_empty # we can't empty the whole contact list...
		contacts.first.must_be_instance_of PerfectReach::Contact

		# PerfectReach::Contact#infos
		contacts.first.infos["mails_clicked"].wont_be_nil
	end
end
