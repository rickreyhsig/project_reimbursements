require_relative '../src/project'
require 'test/unit'
require 'date'
# require 'byebug'

class TestProjects < Test::Unit::TestCase
  @@project = Project.new(Date.new(2023, 5, 1), Date.new(2023, 5, 10), :low)

  def test_total_days
    assert_equal( @@project.total_days, 10 )
  end

  def test_travel_days
    assert_equal( @@project.travel_days, 2 )
  end

  def test_full_days
    assert_equal( @@project.full_days, 8 )
  end
end
