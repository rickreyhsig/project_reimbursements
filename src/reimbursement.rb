class Reimbursement
  attr_accessor :project_set

  def initialize(project_set)
    @project_set = project_set
  end

  def amount
    total_amount = 0
    previous_end_date = nil
    project_set.each do |project|
      unless has_overlap?(project, previous_end_date)
        travel_amount = project.travel_days * Project::RATES[:travel][project.city_type]
        daily_amount = project.full_days * Project::RATES[:full][project.city_type]

        total_amount += travel_amount + daily_amount
      else
      end
    end
    return total_amount
  end

  # TODO
  def has_overlap?(project, previous_project_end_date = nil)
    return false
  end
end