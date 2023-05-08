require 'date'
require 'byebug'

class Project
  attr_accessor :start_date, :end_date, :city_type
  RATES = {
    travel: {
      low: 45,
      high: 55
    },
    full: {
      low: 75,
      high: 85
    }
  }

  def initialize(start_date, end_date, city_type)
    @start_date = start_date
    @end_date = end_date
    @city_type = city_type
  end

  def total_days
    (end_date - start_date + 1).to_i
  end

  def travel_days
    total_days > 2 ? 2 : 1
  end

  def full_days(previous_project_end_date = nil)
    if previous_project_end_date.nil?
      (end_date - start_date - 1).to_i
    else
      (end_date - previous_project_end_date - 1).to_i
    end
  end
end
