class Event < ActiveRecord::Base
  
  validates_presence_of :name, :description, :group_id, :location_id, :start_date, :end_date
  
  validate :location_is_free_those_days
  validate :start_is_on_or_before_end
  
  belongs_to :group
  belongs_to :location
  
  private
  
  def location_is_free_those_days
    return if self.start_date.nil?
    return if self.end_date.nil?
    start = self.start_date
    stop = self.end_date
    conflicts = 0
    (start..stop).each {|day|
      begin
        Event.find(self.id)
        conditions = ["? between start_date and end_date and location_id = ? and id <> ?", day, self.location_id, self.id]
      rescue
        conditions = ["? between start_date and end_date and location_id = ?", day, self.location_id]
      end
      conflicts += Event.find(
        :all, 
        :conditions => conditions 
      ).size
    }
    errors.add(:location_id, "already has an event scheduled for the dates chosen.") if conflicts > 0
  end
  
  def start_is_on_or_before_end
    return if self.start_date.nil?
    return if self.end_date.nil?
    errors.add(:start_date, "must occur on or before the End Date.") if self.start_date > self.end_date
  end
end
