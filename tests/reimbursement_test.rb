require_relative '../src/reimbursement'
require_relative '../src/project'
require 'test/unit'
require 'date'
# require 'byebug'

class TestReimbursements < Test::Unit::TestCase
  def test_single_project
    _start = Date.new(2015, 9, 1)
    _end = Date.new(2015, 9, 3)
    project = Project.new(_start, _end, :low)
    reimbursement = Reimbursement.new([project])

    assert_equal( reimbursement.amount, 165 )
  end
end
