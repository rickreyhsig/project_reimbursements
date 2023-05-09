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
    merge_projects
    merged_values.inject(:+)
  end

  def merge_projects
    daily_values = []

    if project_set.length <= 1
      first_project = project_set.first
      get_daily_values(first_project, daily_values, first_project.city_type, false)
    end

    merged = [project_set.first]

    project_set[1..-1].each_with_index do |project, idx|
      # Project needs to be merged
      if project.start_date <= merged.last.end_date
        city_type = (merged.last.city_type == :high || project.city_type == :high) ? :high : :low

        overlap_days = overlap_days(project_set[idx].start_date, project_set[idx].end_date, project_set[idx+1].start_date, project_set[idx+1].end_date)
        overlap_days.times { daily_values.pop }

        merged.last.end_date = [merged.last.end_date, project.end_date].max
        merged.last.city_type = project_set[idx+1].city_type

        get_overlapped_daily_values(merged.last, daily_values, city_type, true, overlap_days, project_set[idx+1].start_date)
      else
        if idx == 0
          first_project = project_set[0]
          get_daily_values(first_project, daily_values, first_project.city_type, false)
        end
        merged << project
        get_daily_values(project, daily_values, project.city_type, false)
      end
    end
    
    @merged_values = daily_values
  end

  def overlap_days(d1, d2, d3, d4)
    date_range1 = d1..d2
    date_range2 = d3..d4

    overlap_days = (date_range1.to_a & date_range2.to_a).size
  end

  # Daily values leverage the merging of project dates to find
  # what daily reimbusement values should be assigned.
  def get_overlapped_daily_values(merged_project, daily_values, type, merge=false, overlapped_days=0, merge_date)
    if overlapped_days > 0
      (merged_project.start_date..merged_project.start_date + overlapped_days - 1).each_with_index do |cur_date, idx|
        daily_values << RATES[:full][type]
      end
      (merge_date + overlapped_days..merged_project.end_date - 1).each_with_index do |cur_date, idx|
        daily_values << RATES[:full][merged_project.city_type]
      end
      daily_values << RATES[:travel][merged_project.city_type] if merged_project.end_date == project_set.last.end_date
    end
  end

  def get_daily_values(merged_project, daily_values, type, merged=false)
    (merged_project.start_date..merged_project.end_date).each_with_index do |cur_date, idx|
      if (idx == 0)
        if merged
          daily_values << RATES[:full][type]
        else
          daily_values << RATES[:travel][type]
        end
      elsif (idx == merged_project.total_days - 1)
        daily_values << RATES[:travel][type]
      else
        daily_values << RATES[:full][type]
      end
    end
  end
end
