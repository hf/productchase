require "rails_helper"

describe TimeAgo do

  describe "month validation" do
    before :each do
      expect(Time).to receive(:now).twice.and_return(Time.new(2014,10,13,16,4,12))
      @time_month = TimeAgo.new(1.month.ago)
    end

    it "should equal true" do
      expect(@time_month.is_months?).to eq true 
    end

    it "should format time as month/day/year" do
      expect(@time_month.format_time).to eq "09/13/2014" 
    end
  end

  describe "day validation" do
    before :each do
      @time_day = TimeAgo.new(1.day.ago)
    end

    it "should equal true" do
      expect(@time_day.is_days?).to eq true 
    end

    it 'should format time as 1d' do
      expect(@time_day.format_time). to eq "#{@time_day.days}d"
    end
  end

  describe "hour validation" do
    before :each do
      @time_hour = TimeAgo.new(1.hour.ago)
    end

    it 'should equal true' do
      expect(@time_hour.is_hours?).to eq true
    end

    it 'should format time as 1h' do
      expect(@time_hour.format_time).to eq "#{@time_hour.hours}h"
    end
  end

  describe "minute validation" do
    before :each do
      @time_minute = TimeAgo.new(1.minute.ago)
    end

    it "should equal true" do
      expect(@time_minute.is_minutes?).to eq true
    end

    it "should format time as 1m" do
      expect(@time_minute.format_time).to eq "#{@time_minute.minutes}m"
    end
  end

  describe "second validation" do
    before :each do
      @time_second = TimeAgo.new(1.second.ago)
    end

    it "should equal true" do
      expect(@time_second.seconds).to eq 1
    end

    it "should format time as 1s" do
      expect(@time_second.format_time).to eq "#{@time_second.seconds}s"
    end
  end
end