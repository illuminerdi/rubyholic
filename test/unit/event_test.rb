require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  test "event has a name" do
    event = events(:one)
    event.name = ""
    
    assert ! event.valid?
    assert event.errors.on(:name)
  end
  
  test "event has a description" do
    event = events(:one)
    event.description = ""
    
    assert ! event.valid?
    assert event.errors.on(:description)
  end
  
  test "event has a start_date" do
    event = events(:one)
    event.start_date = ""
    
    assert ! event.valid?
    assert event.errors.on(:start_date)
  end
  
  test "event has an end_date" do
    event = events(:one)
    event.end_date = ""
    
    assert ! event.valid?
    assert event.errors.on(:end_date)
  end
  
  test "event has a group" do
    event = events(:one)
    event.group_id = nil
    
    assert ! event.valid?
    assert event.errors.on(:group_id)
  end
  
  test "event has a location" do
    event = events(:one)
    event.location_id = nil
    
    assert ! event.valid?
    assert event.errors.on(:location_id)
  end
  
  test "event does not conflict with other event in same place on same day" do
    event = events(:three)
    event.location_id = events(:ten).location_id
    event.start_date = events(:ten).start_date
    event.end_date = events(:ten).end_date
    
    assert ! event.valid?
    assert event.errors.on(:location)
  end
end
