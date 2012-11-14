require "debugger"

class DateSetter
  Infinity = 1.0 / 0.0
  attr_accessor :reference_date, :min_date, :max_date, :result, :range, :start_of_day, :end_of_day

  def initialize(options = {})
    options.each do |key, value|
      send "#{key}=", value
    end
  end

  def self.set(reference_date, range, options = {})
    options.merge!(reference_date: reference_date, range: range)
    new(options).result
  end

  def valid?
    return false if !reference_date || !range || !valid_ranges?
    (min_date.to_f..max_date.to_f).cover?(reference_date.to_f)
  end

  def invalid?
    !valid?
  end

  def reference_date
    @reference_date.try(:to_datetime)
  end

  def min_date
    @min_date.try(:to_datetime) || min_date_range - 1.second
  end

  def max_date
    @max_date.try(:to_datetime) || max_date_range + 1.second
  end

  def result
    if valid?
      if the_same_day?
        min_date_in_range + rand(intersection_of_range_and_hours_range)
      elsif result_day == min_date_in_range
        result_day + rand(hours_range_when_min_date)
      elsif result_day == max_date_in_range
        result_day + rand(hours_range_when_max_date)
      else
        result_day + rand(start_of_day..end_of_day)
      end
    else
      debugger
      raise ArgumentError, "Some argument is invalid"
    end
  end

  def result_day
    rand(min_date_in_range..max_date_in_range)
  end

  def start_of_day
    @start_of_day ||= 0.hours
  end

  def end_of_day
    @end_of_day ||= 24.hours - 1.second
  end

  def max_date_time_hour
    if max_date_time_in_range.hour > 0
      max_date_time_in_range.hour.hours
    else
      24.hours - 1.second
    end
  end

  def intersection(first_range, second_range)
    return nil if (first_range.max < second_range.begin or second_range.max < first_range.begin)
    [first_range.begin, second_range.begin].max..[first_range.max, second_range.max].min
  end

  def intersection_of_range_and_hours_range
    intersection((min_date_time_in_range.hour.hours..max_date_time_in_range.hour.hours), (start_of_day..end_of_day))
  end

  def hours_range_when_min_date
    (min_date_time_in_range.hour.hours..end_of_day)
  end

  def hours_range_when_max_date
    (start_of_day..max_date_time_hour)
  end

  def the_same_day?
    min_date_in_range == max_date_in_range
  end

  private
  def valid_ranges?
    min_date.to_f <= max_date.to_f && start_of_day.to_f <= end_of_day.to_f && valid_hours_range
  end

  def valid_hours_range
    return true if !the_same_day?
    intersection_of_range_and_hours_range != nil
  end

  def min_date_time_in_range
    if (min_date_range).to_f < min_date.to_f
      min_date
    else
      min_date_range
    end
  end

  def min_date_in_range
    min_date_time_in_range.to_date
  end

  def max_date_time_in_range
    if (max_date_range).to_f > max_date.to_f
      max_date
    else
      max_date_range
    end
  end

  def max_date_in_range
    max_date_time_in_range.to_date
  end

  def min_date_range
    reference_date - range
  end

  def max_date_range
    reference_date + range
  end
end
