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
  
  test "location has an address" do
    location = locations(:one)
    location.address = ""
    
    assert ! location.valid?
    assert location.errors.on(:name)
  end
end
