require_relative '../src/project'
require 'test/unit'
require 'date'

class TestProjects < Test::Unit::TestCase
  _start = Date.new(2023, 5, 1)
  _end = Date.new(2023, 5, 10)
  @@project = Project.new(_start, _end, :low)

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