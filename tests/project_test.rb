require_relative '../src/project'
require 'test/unit'
require 'date'

class TestProjects < Test::Unit::TestCase
  def test_total_days
    project = Project.new(Date.new(2023, 5, 1), Date.new(2023, 5, 10), :low)

    assert_equal( project.total_days, 10 )
  end
end
