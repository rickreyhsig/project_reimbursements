class Project
  attr_accessor :start_date, :end_date, :city_type
  
  def initialize(start_date, end_date, city_type)
    @start_date = start_date
    @end_date = end_date
    @city_type = city_type
  end
end