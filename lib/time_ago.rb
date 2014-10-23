class TimeAgo
  attr_reader :seconds

  def initialize(time = Time.now)
    @seconds = (Time.now - time).round
    @time = time
  end

  def is_months?
    30 <= months
  end

  def is_days?
    days.between?(1,29)
  end

  def is_hours?
    hours.between?(1,24)
  end

  def is_minutes?
    minutes.between?(1,60)
  end

  def is_seconds?
    @seconds.between?(0,60)
  end

  def months
    @seconds/(3600*2)
  end

  def days
    seconds/(3600*24)
  end

  def hours
    seconds/3600
  end

  def minutes
    seconds/60
  end

  def format_time
    return @time.strftime "%m/%d/%Y"    if is_months?
    return @time.strftime "#{days}d"    if is_days? 
    return @time.strftime "#{hours}h"   if is_hours?
    return @time.strftime "#{minutes}m" if is_minutes?
    return @time.strftime "#{seconds}s"
  end
end