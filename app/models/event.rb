class Event < ActiveRecord::Base
  
  validates_presence_of :name, :description, :group_id, :location_id, :start_date, :end_date
  
  validate :location_is_free_those_days
  
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
      conflicts += Event.find(
        :all, 
        :conditions => ["start_date <= ? and end_date >= ? and location_id = ? and id <> ?", day, day, self.location_id, self.id]
      ).size
    }
    errors.add(:location, "This location already has an event scheduled for the dates chosen.") if conflicts > 0
  end
end
