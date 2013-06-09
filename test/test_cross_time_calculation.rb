# encoding: UTF-8

require 'test/unit'
require 'time'
require 'cross_time_calculation'

class TestCrossTimeCalculation < Test::Unit::TestCase
  def setup
    # the first pair
    @t1 = DateTime.parse("20130512").to_time
    @t2 = @t1 + 33

    @ctc = CrossTimeCalculation.new
    @ctc.add @t1, @t2

    # the second pair
    @t3 = DateTime.parse("20130512 10:51:03").to_time
    @t4 = DateTime.parse("20130512 14:21:24").to_time

    # the third pair
    @t5 = DateTime.parse("20130512 18:32:28").to_time
    @t6 = DateTime.parse("20130512 23:19:31").to_time

    # the forth pair crossed with the third pair
    @t7 = DateTime.parse("20130512 20").to_time
    @t8 = DateTime.parse("20130513 13").to_time
  end

  def test_empty
    assert_equal CrossTimeCalculation.new.total_seconds, 0
  end

  def test_one_time_point
    assert_equal @ctc.total_seconds, 33
  end

  def test_more_time_points
    @ctc.add @t3, @t4
    @ctc.add @t5, @t6
    compute = (@t2 - @t1) + (@t4 - @t3) + (@t6 - @t5)
    compare = (@ctc.total_seconds - compute).abs < 1
    assert_equal compare, true
  end

  def test_more_time_points_with_cross
    @ctc.add @t3, @t4
    @ctc.add @t5, @t6
    @ctc.add @t7, @t8

    # user array to count appeared second
    @seconds = []
    [[@t1, @t2], [@t3, @t4], [@t5, @t6], [@t7, @t8]].each do |tb, te|
      new_idx = tb - @t1
      (te-tb).to_i.times {|idx| @seconds[new_idx+idx] = 1 }
    end

    compare = (@seconds.count(1) - @ctc.total_seconds).abs < 3

    assert_equal compare, true
  end

end
