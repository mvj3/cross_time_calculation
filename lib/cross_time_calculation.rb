# encoding: UTF-8

class CrossTimeCalculation
  TimePoint = Struct.new(:t, :status)
  attr_accessor :time_points

  def initialize
    self.time_points = Array.new
  end

  def add *time_begin_and_end
    # init TimePoint pair
    tb = TimePoint.new(time_begin_and_end[0], :started_at)
    te = TimePoint.new(time_begin_and_end[1], :finished_at)

    # validate data
    raise "At least the begin time should exist" if not tb
    raise "The begin time should not larger than the end time" if tb.t > te.t

    # insert it and sort
    self.time_points += [tb, te]
    self.time_points = self.time_points.uniq {|i| "#{i.t}#{i.status}" }.sort {|a, b| a.t <=> b.t }

    # TODO optimize search with idx
    loop do
      to_removes = []
      self.time_points.each_with_index do |tp, idx|
        post_tp = self.time_points[idx+1]
        next if post_tp.nil?
        # delete the first one if they are all finished_at
        to_removes << tp if (tp.status == :finished_at) && (post_tp.status == :finished_at)
        # delete the later one if they are all started_at
        to_removes << post_tp if (tp.status == :started_at) && (post_tp.status == :started_at)
      end
      self.time_points -= to_removes

      break if data_valid?
    end

    return self
  end

  def total_seconds
    result = 0
    self.time_points.each_slice(2) do |a|
      end_time = a[1].nil? ? Time.now : a[1].t
      result += (end_time - a[0].t)
    end
    result
  end

  # start time and end time interval is supposed to exist
  def data_valid?
    valids = []
    self.time_points.each_slice(2) do |tp_start, tp_finish|
      valids << (tp_start.status != tp_finish.status)
    end
    valids.count(false).zero?
  end

end
