class DateSetter
  Infinity = 1.0 / 0.0
  attr_accessor :reference_date, :min_date, :max_date

  def valid?
    return unless @reference_date || @min_date > @max_date
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
end
