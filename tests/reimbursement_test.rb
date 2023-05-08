require_relative '../src/reimbursement'
require_relative '../src/project'
require 'test/unit'
require 'date'
require 'byebug'

class TestReimbursements < Test::Unit::TestCase
  def test_single_project
    _start = Date.new(2015, 9, 1)
    _end = Date.new(2015, 9, 3)
    project = Project.new(_start, _end, :low)
    reimbursement = Reimbursement.new([project])

    assert_equal( reimbursement.amount, 165 )
    assert_equal( reimbursement.merged_values, [45, 75, 45] )
  end

  def test_multiple_projects_no_merge
    _start = Date.new(2015, 9, 1)
    _end = Date.new(2015, 9, 3)
    project1 = Project.new(_start, _end, :low)

    _start = Date.new(2015, 9, 5)
    _end = Date.new(2015, 9, 7)
    project2 = Project.new(_start, _end, :high)

    _start = Date.new(2015, 9, 8)
    _end = Date.new(2015, 9, 8)
    project3 = Project.new(_start, _end, :high)

    reimbursement = Reimbursement.new([project1, project2, project3])
    assert_equal( reimbursement.amount, 415 )
    assert_equal( reimbursement.merged_values, [45, 75, 45, 55, 85, 55, 55] )
  end

  def test_merge
    # TODO
  end
end
