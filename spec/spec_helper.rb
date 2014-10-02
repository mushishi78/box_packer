RSpec.configure do |config|

	config.expect_with :rspec do |expectations|
		expectations.include_chain_clauses_in_custom_matcher_descriptions = true
	end

	config.mock_with :rspec do |mocks|
		mocks.verify_partial_doubles = true
	end

	require_relative '../lib/box_packer'
	Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}
	config.include BoxPacker::Matchers
end
