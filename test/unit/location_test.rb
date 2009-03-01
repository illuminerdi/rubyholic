require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "location has a name" do
    location = locations(:one)
    location.name = ""
    
    assert ! location.valid?
    assert location.errors.on(:name)
  end
  
  test "location name is distinct if address is the same" do
    location = locations(:one)
    location.name = locations(:two).name
    location.address = locations(:two).name
    
    assert ! location.valid?
    assert location.errors.on(:name)
  end
  
  test "duplicate location name with different address" do
    
  end
  
  test "location has an address" do
    location = locations(:one)
    location.address = ""
    
    assert ! location.valid?
    assert location.errors.on(:address)
  end
  
  test "location description is not freaking huge" do
    location = locations(:one)
    location.notes = (0..26).map {|i| i.to_s * 72}.to_s
    
    assert ! location.valid?
    assert location.errors.on(:notes)
  end
  
  test "new location auto-populates long and lat" do
    location = Location.new(
      :name => "Cafe Migliore",
      :address => "1215 4th Ave, Seattle, WA 98101",
      :notes => "Large meeting table and comfortable benches. Good coffee made...okay. Nice waitstaff. Big screen television is a bit of a distraction."
    )
    assert location.valid?
    assert ! location[:latitude].nil?
    assert ! location[:longitude].nil?
  end
end
