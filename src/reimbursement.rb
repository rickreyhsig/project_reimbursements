class Reimbursement
  attr_accessor :project_set, :merged_values
  RATES = {
    travel: {
      low: 45, high: 55
    },
    full: {
      low: 75, high: 85
    }
  }

  def initialize(project_set)
    @project_set = project_set
    @merged_values = nil
  end

  def amount
    # total_amount = 0
    # previous_end_date = nil
    # project_set.each do |project|
    #   unless has_overlap?(project, previous_end_date)
    #     travel_amount = project.travel_days * Project::RATES[:travel][project.city_type]
    #     daily_amount = project.full_days * Project::RATES[:full][project.city_type]

    #     total_amount += travel_amount + daily_amount
    #   else
    #   end
    # end
    # return total_amount
    merge_projects
    merged_values.inject(:+)
  end

  def merge_projects
    daily_values = []

    if project_set.length <= 1
      first_project = project_set.first
      get_daily_values(first_project, daily_values, first_project.city_type, false, 0, nil)
    end

    merged = [project_set.first]

    project_set[1..-1].each_with_index do |project, idx|
      if project.start_date <= merged.last.end_date
        # p '-- NEEDS TO MERGE--'
        city_type = (merged.last.city_type == :high || project.city_type == :high) ? :high : :low

        overlap_days = overlap_days(project_set[idx].start_date, project_set[idx].end_date, project_set[idx+1].start_date, project_set[idx+1].end_date)
        # p overlap_days
        overlap_days.times { daily_values.pop }

        merged.last.end_date = [merged.last.end_date, project.end_date].max
        merged.last.city_type = project_set[idx+1].city_type

        get_daily_values(merged.last, daily_values, city_type, true, overlap_days, project_set[idx+1].start_date)
      else
        # p '-- NO NEED TO MERGE--'
        if idx == 0
          first_project = project_set[0]
          get_daily_values(first_project, daily_values, first_project.city_type, false, 0, nil) 
        end
        merged << project
        get_daily_values(project, daily_values, project.city_type, false, 0, nil)
      end
    end
    
    @merged_values = daily_values
  end

  def overlap_days(d1, d2, d3, d4)
    date_range1 = d1..d2
    date_range2 = d3..d4

    overlap_days = (date_range1.to_a & date_range2.to_a).size
  end

  def get_daily_values(merged_project, daily_values, type, merge=false, overlap_days=0, merge_date)
    # byebug
    if overlap_days > 0
      (merged_project.start_date..merged_project.start_date + overlap_days - 1).each_with_index do |cur_date, idx|
        daily_values << RATES[:full][type]
        # byebug
      end
      (merge_date + overlap_days..merged_project.end_date - 1).each_with_index do |cur_date, idx|
        daily_values << RATES[:full][merged_project.city_type]
        # byebug
      end
      # byebug
      daily_values << RATES[:travel][merged_project.city_type] if merged_project.end_date == project_set.last.end_date
      # byebug
      # p daily_values
      return
    end

    (merged_project.start_date..merged_project.end_date).each_with_index do |cur_date, idx|
      if (idx == 0)
        if merge
          daily_values << RATES[:full][type]
          # p RATES[:full][type]
        else
          daily_values << RATES[:travel][type]
          # p RATES[:travel][type]
        end
      elsif (idx == merged_project.total_days - 1)
        daily_values << RATES[:travel][type]
        # p RATES[:travel][type]
      else
        daily_values << RATES[:full][type]
        # p RATES[:full][type]
      end
    end
  end
end