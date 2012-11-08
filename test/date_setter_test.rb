require "test_helper"

class DateSetterTest < MiniTest::Unit::TestCase

  def setup
    @date_setter = DateSetter.new
    @date_setter.reference_date = DateTime.now
    @date_setter.range = 0.days
  end

  def test_setup_is_valid
    assert @date_setter.valid?
  end

  def test_is_invalid_when_reference_date_is_smaller_than_min
    @date_setter.reference_date = 3.days.ago
    @date_setter.min_date = 2.days.ago

    assert @date_setter.invalid?
  end

  def test_is_invalid_when_reference_date_is_bigger_than_max
    @date_setter.reference_date = 3.days.from_now
    @date_setter.max_date = 2.days.from_now

    assert @date_setter.invalid?
  end

  def test_is_invalid_when_reference_date_is_bigger_than_min_and_max
    @date_setter.reference_date = 3.days.from_now
    @date_setter.min_date = 2.days.ago
    @date_setter.max_date = 2.days.from_now

    assert @date_setter.invalid?
  end

  def test_is_invalid_when_reference_date_is_smaller_than_min_and_max
    @date_setter.reference_date = 3.days.ago
    @date_setter.min_date = 2.days.ago
    @date_setter.max_date = 2.days.from_now

    assert @date_setter.invalid?
  end

  def test_is_invalid_when_reference_date_is_bigger_than_max_and_min
    @date_setter.reference_date = 3.days.from_now
    @date_setter.max_date = 2.days.ago
    @date_setter.min_date = 2.days.from_now

    assert @date_setter.invalid?
  end

  def test_is_invalid_when_reference_date_is_smaller_than_max_and_min
    @date_setter.reference_date = 3.days.ago
    @date_setter.max_date = 2.days.ago
    @date_setter.min_date = 2.days.from_now

    assert @date_setter.invalid?
  end

  def test_is_invalid_without_reference_date
    @date_setter.reference_date = nil
    @date_setter.min_date = 2.days.ago
    @date_setter.max_date = 2.days.from_now

    assert @date_setter.invalid?
  end

  def test_is_valid_when_reference_date_is_bigger_than_min
    @date_setter.min_date = 2.days.ago

    assert @date_setter.valid?
  end

  def test_is_valid_when_reference_date_is_smaller_than_max
    @date_setter.max_date = 2.days.from_now

    assert @date_setter.valid?
  end

  def test_is_valid_when_reference_date_is_between_min_and_max
    @date_setter.min_date = 2.days.ago
    @date_setter.max_date = 2.days.from_now

    assert @date_setter.valid?
  end

  def test_is_valid_when_reference_date_is_equal_to_min
    @date_setter.reference_date = @date_setter.min_date = 2.days.ago

    assert @date_setter.valid?
  end

  def test_is_valid_when_reference_date_is_equal_to_max
    @date_setter.reference_date = @date_setter.max_date = 2.days.from_now

    assert @date_setter.valid?
  end

  def test_should_always_return_result_which_is_between_min_date_and_max_date
    @date_setter.reference_date = @date_setter.min_date = @date_setter.max_date = DateTime.now
    @date_setter.range = 5.days

    assert (0.days.ago.at_midnight..1.days.from_now.at_midnight).cover?(@date_setter.result)
  end

  def test_should_always_return_result_which_is_between_min_hour_and_max_hour
    @date_setter.min_hour = 8.hours
    @date_setter.max_hour = 9.hours

    assert (8..9).cover?(@date_setter.result.hour)
  end

  def test_set_function_should_generate_correct_date
    set_date_time = DateSetter.set(0.days.ago, 0.days)

    assert_equal Date.today, set_date_time.to_date
  end
end