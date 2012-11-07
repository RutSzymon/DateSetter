class DateSetter
  Infinity = 1.0 / 0.0
  attr_accessor :reference_date, :min_date, :max_date, :result, :range

  def valid?
    return unless @reference_date || @range || min_date.to_f > max_date.to_f
    (min_date.to_f..max_date.to_f).cover?(@reference_date.to_f)
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
    @result = rand(min_date_in_range..max_date_in_range) if valid?
  end

  def min_date_in_range
    if (reference_date - range).to_f < min_date.to_f
      min_date
    else
      reference_date - range
    end
  end

  def max_date_in_range
    if (reference_date + range).to_f > max_date.to_f
      max_date
    else
      reference_date + range
    end
  end
end
