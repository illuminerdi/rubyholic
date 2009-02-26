require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
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
  end
end
