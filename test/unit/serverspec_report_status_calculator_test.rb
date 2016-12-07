require 'test_helper'
class ServerspecReportStatusCalculatorTest < ActiveSupport::TestCase
  test 'it should save metrics as bits in status integer' do
    r = ServerspecReportStatusCalculator.new(:counters => {'example_count' => 92, 'failure_count' => 4, 'pending_count' => 10})
    assert_equal 4, r.status['failure_count']
    assert_equal 10, r.status['pending_count']
    assert_equal 92, r.status['example_count']
  end
end
