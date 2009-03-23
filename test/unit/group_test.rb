require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  
  test "group has a name" do
    group = groups(:one)
    group.name = ""
    assert ! group.valid?
    assert group.errors.on(:name)
  end
  
  test "group name is unique" do
    group = groups(:one)
    group.name = groups(:two).name
    assert ! group.valid?
    assert group.errors.on(:name)
  end
  
  test "group url is valid" do
    group = groups(:one)
    group.url = "asdf"
    assert ! group.valid?
    assert group.errors.on(:url)
  end
  
  test "group has a reasonably-sized description" do
    group = groups(:one)
    group.description = (0..26).map {|i| i.to_s * 72}.to_s
    assert ! group.valid?
    assert group.errors.on(:description)
    assert_match /255/, group.errors.on(:description)
  end
  
  test "group events are in order by start date in ascension" do
    group = groups(:one)
    assert group.events.first.start_date <= group.events.last.start_date
  end
end
