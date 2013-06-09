# encoding: UTF-8

class CrossTimeCalculation
  TimePoint = Struct.new(:t, :status)
  attr_accessor :time_points

  def initialize
    self.time_points = Array.new
  end

  def add *time_begin_and_end
    # validate data
    raise "The begin and end time all should exist" if time_begin_and_end.size != 2
    raise "The begin time should not larger than the end time" if time_begin_and_end[0] > time_begin_and_end[1]

    # init TimePoint pair
    tb = TimePoint.new(time_begin_and_end[0], :started_at)
    te = TimePoint.new(time_begin_and_end[1], :finished_at)

    # insert it and sort
    self.time_points += [tb, te]
    self.time_points = self.time_points.sort {|a, b| a.t <=> b.t }

    # TODO optimize search with idx
    self.time_points.each_with_index do |tp, idx|
      # skip the first TimePoint
      if not idx.zero?
        post_tp = self.time_points[idx+1]
        # skip the last TimePoint
        next if post_tp.nil?
        # delete the later one if they are all started_at
        self.time_points.delete post_tp if (tp.status == :started_at) && (post_tp.status == :started_at)
        # delete the first one if they are all finished_at
        self.time_points.delete tp if (tp.status == :finished_at) && (post_tp.status == :finished_at)
      end
    end

    return self
  end

  def total_seconds
    result = 0
    self.time_points.each_slice(2) do |a|
      result += (a[1].t - a[0].t)
    end
    result
  end

end
