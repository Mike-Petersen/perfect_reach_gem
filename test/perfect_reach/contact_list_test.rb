require 'minitest_helper'

describe PerfectReach::ContactList do
	it 'has an integration suite, tested directly against PerfectReach service' do
		# clean-up all existing lists:
		PerfectReach::ContactList.all.each do |list|
			list.delete.must_equal "ok"
		end

		# PerfectReach::ContactList.all for no lists
		PerfectReach::ContactList.all.must_be_empty

		exception = proc { PerfectReach::ContactList.create(name: 'My PerfectReach list') }.must_raise(PerfectReach::ApiError)
		exception.to_s.must_match /invalid_language/

		# PerfectReach::ContactList#create
		list = PerfectReach::ContactList.create(name: 'My PerfectReach list', sign_up_allowed: true, show_in_index: false, category_ids: nil,
															 title: 'My PerfectReach list', description: 'My Description', language: 'de', homepage_url: 'http://www.perfect-reach.com')
		list.must_be_instance_of PerfectReach::ContactList
		list.name.must_equal 'My PerfectReach list'
		list.title.must_equal 'My PerfectReach list'
		list.sign_up_allowed.must_equal true
		list.show_in_index.must_equal false
		list.description.must_equal 'My Description'
		list.homepage_url.must_equal 'http://www.perfect-reach.com'

		# PerfectReach::ContactList#update.
		list.update(:name => 'My updated PerfectReach list', :title => "myupdatedPerfectReachlist").must_equal "ok"
		updated_list = PerfectReach::ContactList.all.first
		updated_list.name.must_equal 'My updated PerfectReach list'
		updated_list.title.must_equal 'myupdatedPerfectReachlist'
		updated_list.id.must_equal list.id

		# PerfectReach::ContactList.all
		lists = PerfectReach::ContactList.all
		lists.count.must_equal 1
		lists.first.must_be_instance_of PerfectReach::ContactList
		lists.first.id.must_equal updated_list.id

		# PerfectReach::ContactList#add_contacts
		list.add_contacts([{email: "c1@contacts.com", name: 'c1'}]).must_equal "ok"
		list.add_contacts([{email: "c1@contacts.com", name: 'c1'}]).must_equal "not_modified"
		list.add_contacts([{email: "c2@contacts.com", name: 'c2'}, {email: "c3@contacts.com", name: 'c3'}]).must_equal "ok"
		list.add_contacts([{email: "c4@contacts.com", name: 'c4'}, {email: "c5@contacts.com", name: 'c5'}]).must_equal "ok"

		# PerfectReach::ContactList#contacts and validate results of add_contacts
		contacts = list.contacts
		contacts.first.must_be_instance_of PerfectReach::Contact
		contacts.map(&:email).sort.must_equal ["c1@contacts.com", "c2@contacts.com", "c3@contacts.com", "c4@contacts.com", "c5@contacts.com"]

		# PerfectReach::ContactList#unsubscribe_contact
		list.unsubscribe_contact("c1@contacts.com").must_equal "ok"
		exception = proc { list.unsubscribe_contact("c1@contacts.com") }.must_raise(PerfectReach::ApiError)
		exception.to_s.must_match /already_unsubscribed/

		# PerfectReach::ContactList#remove_contacts
		list.remove_contacts([{email: "does-not-exist@nowhere.com"}]).must_equal "not_modified"
		list.remove_contacts([{email: "c1@contacts.com"}, {email: "c2@contacts.com"}]).must_equal "ok"
		list.contacts.count.must_equal 3

		# PerfectReach::ContactList#email
		list.email.must_match /\@lists\.perfect-reach\.com$/

		# PerfectReach::ContactList#statistics
		list.statistics["sent"].must_equal 0

		# PerfectReach::ContactList#delete
		list.delete.must_equal 'ok'
		PerfectReach::ContactList.all.must_be_empty
		exception = proc { list.delete }.must_raise(PerfectReach::ApiError)
		exception.to_s.must_match /invalid_id/
	end
end
