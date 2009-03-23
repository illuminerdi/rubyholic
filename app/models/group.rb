class Group < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_length_of :description, :maximum => 255, 
    :message => "Description should be less than {{count}} characters in length"
  
  has_one :event
  has_many :events, :order => "events.start_date ASC"
  has_many :locations, :through => :events
  has_one :location, :through => :event
    
  validates_format_of :url, 
    :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
    :message => "URL does not appear to be valid (ex: http://...)",
    :unless => :url.nil?
end
