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
    @reference_date.is_a?(Date) ? @reference_date.at_beginning_of_day : @reference_date
  end

  def min_date
    if @min_date.is_a?(Date)
      @min_date.at_beginning_of_day
    else
      @min_date || min_date_range - 1.second
    end
  end

  def max_date
    if @max_date.is_a?(Date)
      @max_date.at_beginning_of_day
    else
      @max_date || max_date_range + 1.second
    end
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
      exception
    end
  end

  def result_day
    @result_day ||= rand(min_date_in_range..max_date_in_range)
  end

  def start_of_day
    @start_of_day ||= 0.hours
  end

  def end_of_day
    @end_of_day ||= 24.hours - 1.second
  end

  def intersection(first_range, second_range)
    return nil if (first_range.max < second_range.begin or second_range.max < first_range.begin)
    [first_range.begin, second_range.begin].max..[first_range.max, second_range.max].min
  end

  def intersection_of_range_and_hours_range
    intersection((min_date_time_hour..max_date_time_hour), (start_of_day..end_of_day))
  end

  def hours_range_when_min_date
    (min_date_time_hour..end_of_day)
  end

  def hours_range_when_max_date
    (start_of_day..max_date_time_hour)
  end

  private
  def valid_ranges?
    min_date.to_f <= max_date.to_f && start_of_day.to_f <= end_of_day.to_f && valid_hours_range && hours_range_in_range?
  end

  def the_same_day?
    min_date_in_range == max_date_in_range
  end

  def hours_range_in_range?
    intersection((min_date_range..max_date_range), (reference_date.to_date + start_of_day..reference_date.to_date + end_of_day)) != nil
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

  def valid_min_date_time_in_range
    if min_date_time_in_range > min_date_time_in_range.to_date + end_of_day
      min_date_time_in_range.to_date + 1.day + start_of_day
    else
      min_date_time_in_range
    end
  end

  def min_date_time_hour
    (valid_min_date_time_in_range.to_i - valid_min_date_time_in_range.at_beginning_of_day.to_i).seconds
  end

  def min_date_in_range
    valid_min_date_time_in_range.to_date
  end

  def max_date_time_in_range
    if (max_date_range).to_f > max_date.to_f
      max_date
    else
      max_date_range
    end
  end

  def valid_max_date_time_in_range
    if max_date_time_in_range < max_date_time_in_range.to_date + start_of_day
      max_date_time_in_range.to_date - 1.day + end_of_day
    else
      max_date_time_in_range
    end
  end

  def max_date_time_hour
    if valid_max_date_time_in_range.to_i - valid_max_date_time_in_range.at_beginning_of_day.to_i > 0
      (valid_max_date_time_in_range.to_i - valid_max_date_time_in_range.at_beginning_of_day.to_i).seconds
    else
      24.hours - 1.second
    end
  end

  def max_date_in_range
    valid_max_date_time_in_range.to_date
  end

  def min_date_range
    reference_date - range
  end

  def max_date_range
    reference_date + range
  end

  def exception
    raise ArgumentError, "Some argument is invalid \n
                          reference_date: #{reference_date.inspect} \n
                          range: #{range.inspect} \n
                          min_date: #{min_date.inspect} \n
                          max_date: #{max_date.inspect} \n
                          start_of_day: #{start_of_day.inspect} \n
                          end_of_day: #{end_of_day.inspect}"
  end
end
