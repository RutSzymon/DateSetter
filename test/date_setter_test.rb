require "test_helper"

class DateSetterTest < MiniTest::Unit::TestCase

  def setup
    @date_setter = DateSetter.new
    @date_setter.range = 0.days
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
    @date_setter.min_date = 2.days.ago
    @date_setter.max_date = 2.days.from_now

    assert @date_setter.invalid?
  end

  def test_is_valid_when_reference_date_is_bigger_than_min
    @date_setter.reference_date = 1.days.ago
    @date_setter.min_date = 2.days.ago

    assert @date_setter.valid?
  end

  def test_is_valid_when_reference_date_is_smaller_than_max
    @date_setter.reference_date = 1.days.from_now
    @date_setter.max_date = 2.days.from_now

    assert @date_setter.valid?
  end

  def test_is_valid_when_reference_date_is_between_min_and_max
    @date_setter.reference_date = 1.days.from_now
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

  def test_should_always_return_result_which_is_between_max_and_min
    @date_setter.reference_date = 2.days.from_now
    @date_setter.min_date = @date_setter.reference_date - 1.hour
    @date_setter.max_date = @date_setter.reference_date + 1.hour
    @date_setter.range = 5.days

    assert (@date_setter.min_date..@date_setter.max_date).cover?(@date_setter.result)
  end
end