require 'minitest/autorun'
require 'mocha/setup'
require 'perfect_reach'

test_account = YAML::load(File.new(File.expand_path("../../config.yml", __FILE__)))['perfect_reach']

MiniTest::Spec.before do
	PerfectReach.configure do |config|
		config.api_key = test_account['api_key']
		config.host = test_account['host']
		config.port = test_account['port']
		config.use_https = test_account['use_https']
	end
end

MiniTest::Spec.after do
	Object.send(:remove_const, 'PerfectReach')
	Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each { |f| load f }
end
