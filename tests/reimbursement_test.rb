require_relative '../src/reimbursement'
require_relative '../src/project'
require 'test/unit'
require 'date'

class TestReimbursements < Test::Unit::TestCase
  def test_single_project
    project = Project.new(Date.new(2015, 9, 1), Date.new(2015, 9, 3), :low)
    reimbursement = Reimbursement.new([project])

    assert_equal( reimbursement.amount, 165 )
    assert_equal( reimbursement.merged_values, [45, 75, 45] )
  end

  def test_multiple_projects_no_merge
    project1 = Project.new(Date.new(2015, 9, 1), Date.new(2015, 9, 3), :low)
    project2 = Project.new(Date.new(2015, 9, 5), Date.new(2015, 9, 7), :high)
    project3 = Project.new(Date.new(2015, 9, 8), Date.new(2015, 9, 8), :high)

    reimbursement = Reimbursement.new([project1, project2, project3])
    assert_equal( reimbursement.amount, 415 )
    assert_equal( reimbursement.merged_values, [45, 75, 45, 55, 85, 55, 55] )
  end

  def test_merge
    project1 = Project.new(Date.new(2015, 9, 1), Date.new(2015, 9, 1), :low)
    project2 = Project.new(Date.new(2015, 9, 1), Date.new(2015, 9, 1), :low)
    project3 = Project.new(Date.new(2015, 9, 2), Date.new(2015, 9, 2), :high)
    project4 = Project.new(Date.new(2015, 9, 2), Date.new(2015, 9, 3), :high)

    reimbursement = Reimbursement.new([project1, project2, project3, project4])
    assert_equal( reimbursement.amount, 215 )
    assert_equal( reimbursement.merged_values, [75, 85, 55] )
  end

  def test_merge_two
    project1 = Project.new(Date.new(2015, 9, 1), Date.new(2015, 9, 1), :low)
    project2 = Project.new(Date.new(2015, 9, 2), Date.new(2015, 9, 6), :high)
    project3 = Project.new(Date.new(2015, 9, 6), Date.new(2015, 9, 8), :low)

    reimbursement = Reimbursement.new([project1, project2, project3])
    assert_equal( reimbursement.amount, 560 )
    assert_equal( reimbursement.merged_values, [45, 55, 85, 85, 85, 85, 75, 45] )
  end
end
