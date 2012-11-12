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
    return if !reference_date || !range || !valid_ranges?
    (min_date.to_f..max_date.to_f).cover?(reference_date.to_f)
  end

  def invalid?
    !valid?
  end

  def reference_date
    @reference_date.try(:to_datetime)
  end

  def min_date
    @min_date.try(:to_datetime) || -Infinity
  end

  def max_date
    @max_date.try(:to_datetime) || Infinity
  end

  def result
    rand(min_date_in_range..max_date_in_range) + rand(start_of_day..end_of_day) if valid?
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

  private
  def valid_ranges?
    min_date.to_f <= max_date.to_f || start_of_day.to_f <= end_of_day.to_f
  end

  def min_date_in_range
    if (reference_date - range).to_f < min_date.to_f
      min_date.to_date
    else
      (reference_date - range).to_date
    end
  end

  def max_date_in_range
    if (reference_date + range).to_f > max_date.to_f
      max_date.to_date
    else
      (reference_date + range).to_date
    end
  end
end
