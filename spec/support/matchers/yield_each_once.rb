require 'rspec/matchers/built_in/yield'

module BoxPacker
  module Matchers
    class YieldEachOnce
      attr_init :expected

      def matches?(block)
        @probe = RSpec::Matchers::BuiltIn::YieldProbe.probe(block)
        @actual = @probe.successive_yield_args

        @actual.each do |value|
          unless expected.delete(value)
            @failure_value = value
            return false
          end
        end
        true
      end

      def supports_block_expectations?
        true
      end

      def description
        'be in expected array'
      end

      def failure_message
        "value #{@failure_value.to_a} was not in expected array"
      end
    end

    def yield_each_once(expected)
      YieldEachOnce.new(expected)
    end
  end
end
