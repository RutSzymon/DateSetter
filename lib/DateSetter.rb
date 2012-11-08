class DateSetter
  Infinity = 1.0 / 0.0
  attr_accessor :reference_date, :min_date, :max_date, :result, :range, :min_hour, :max_hour

  def valid?
    return unless reference_date || range || !valid_ranges?
    (min_date.to_f..max_date.to_f).cover?(reference_date.to_f)
  end

  def invalid?
    !valid?
  end

  def min_date
    @min_date ||= -Infinity
  end

  def max_date
    @max_date ||= Infinity
  end

  def result
    rand(min_date_in_range..max_date_in_range) + rand(min_hour..max_hour) if valid?
  end

  def min_hour
    @min_hour ||= 0.hours
  end

  def max_hour
    @max_hour ||= 24.hours - 1.second
  end

  private
  def valid_ranges?
    min_date.to_f < max_date.to_f || min_hour.to_f < max_hour.to_f
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
