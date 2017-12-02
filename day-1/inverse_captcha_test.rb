require "minitest/autorun"
require "minitest/pride"
require_relative './inverse_captcha'

class InverseCaptchaTest < Minitest::Test
  def test_it_exists
    assert InverseCaptcha.new(123)
  end

  def test_it_evaluates_in_order
    assert_equal 3, InverseCaptcha.new(1122).eval
    assert_equal 4, InverseCaptcha.new(1111).eval
    assert_equal 0, InverseCaptcha.new(1234).eval
    assert_equal 9, InverseCaptcha.new(91212129).eval
  end

  def test_it_evaluates_by_half
    assert_equal 6, InverseCaptcha.new(1212).eval_by_half
    assert_equal 0, InverseCaptcha.new(1221).eval_by_half
    assert_equal 4, InverseCaptcha.new(123425).eval_by_half
    assert_equal 12, InverseCaptcha.new(123123).eval_by_half
    assert_equal 4, InverseCaptcha.new(12131415).eval_by_half
  end
end


