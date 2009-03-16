class Location < ActiveRecord::Base
  GOOGLE_MAP_API_KEY = 'ABQIAAAAeB6V9etRslOYUQrgBtxDGhTJQa0g3IQ9GZqIMmInSLzwtGDKaBR_NQCgKy3xzp_0k2xgbpxONlQSSQ'
  
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "address"
  
  validates_length_of :notes, :maximum => 255, 
    :message => "Location notes should be less than {{count}} characters in length"
    
  validates_presence_of :address
  
  has_many :events
  has_many :groups, :through => :events
  
  def address=(new_address)
    loc = locate(new_address)
    
    if loc.success == false
      errors.add(:address, "We were unable to find the address")
      self.latitude = nil
      self.longitude = nil
      new_address = ""
    else
      self.latitude = loc.lat
      self.longitude = loc.lng
      new_address = loc.full_address
    end
    write_attribute(:address, new_address)
  end
  
  def locate(address)
    Geokit::Geocoders::google = GOOGLE_MAP_API_KEY
    Geokit::Geocoders::GoogleGeocoder.geocode "#{address}"
  end
end
