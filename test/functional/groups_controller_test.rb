require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end
  
  test "index should show only ten groups at a time" do
    get :index
    groups = assigns(:groups)
    assert_equal 10, groups.size
  end
  
  test "index should show locations for each group and event entry" do
    get :index
    assert_match /Location/, @response.body
    assert_match /Event/, @response.body
    groups = assigns(:groups)
    groups.each {|group|
      assert @response.body.include?(group.name)
      assert @response.body.include?(group.location.name)
    }
  end
  
  test "index page two should show less than 10 groups" do
    # this is hinky. I want to test pagination and results, but 
    # the number of groups listed will change as the requirements change.
    # teh lamezor.
    get :index, :page => 2
    groups = assigns(:groups)
    assert groups.size < 10
  end
  
  test "sort by name descending does what it should" do
    get :index, :sort => "groups_name_reverse"
    groups = assigns(:groups)
    group_names = Group.find(:all, :select => :name, :order => 'upper(name) DESC')
    
    assert_equal group_names.first[:name], groups.first[:name]
  end
  
  test "sort by location does what it should" do
    get :index, :sort => "locations_name"
    groups = assigns(:groups)
    location_names = Location.find(:all, :select => "name", :order => "upper(locations.name) ASC")
    
    assert_equal location_names.first[:name], groups.first[:location_name]
  end
  
  test "sort by location descending does what it should" do
    get :index, :sort => "locations_name_reverse"
    groups = assigns(:groups)
    location_names = Location.find(:all, :select => "name", :order => "upper(locations.name) ASC")
    
    assert_equal location_names.last[:name], groups.first[:location_name]
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[url]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'group[description]'
    }
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, :group => {
        :name => "test_group_new",
        :url => "http://www.google.com",
        :description => "testing"
      }
    end

    assert_redirected_to group_path(assigns(:group))
  end

  test "should show group" do
    get :show, :id => groups(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => groups(:one).id
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[url]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'group[description]'
    }
  end

  test "should update group" do
    put :update, :id => groups(:one).id, :group => { }
    assert_redirected_to group_path(assigns(:group))
  end
  
  test "should throw error on duplicate group name" do
    put :update, :id => groups(:one).id, :group => {
      :name => groups(:two).name
    }
    assert_response :success
    group = assigns(:group)
    assert ! group.valid?
    assert group.errors.size == 1
    error_msgs = group.errors.full_messages
    error_msgs.each do |error_msg|
      assert @response.body.include?(error_msg)
    end
    assert_select "div.fieldWithErrors" do |elements|
      assert elements.size == 2
    end
  end
  
  test "should allow no url" do
    put :create, :group => {
      :name => "foo",
      :url => "",
      :description => "In this day an age - a new group with no URL."
    }
    assert_redirected_to group_path(assigns(:group))
    
  end
  
  test "should throw error on bad url" do
    put :update, :id => groups(:one).id, :group => {
      :url => "asdf"
    }
    assert_response :success
    group = assigns(:group)
    assert ! group.valid?
    assert group.errors.size == 1
    error_msgs = group.errors.full_messages
    error_msgs.each do |error_msg|
      assert @response.body.include?(error_msg)
    end
    assert_select "div.fieldWithErrors" do |elements|
      assert elements.size == 2
    end
  end
  
  test "should throw error with stupid-big description" do
    put :update, :id => groups(:one).id, :group => {
      :description => (0..26).map {|i| i.to_s * 72}.to_s
    }
    assert_response :success
    group = assigns(:group)
    assert ! group.valid?
    assert group.errors.size == 1
    error_msgs = group.errors.full_messages
    error_msgs.each do |error_msg|
      assert @response.body.include?(error_msg)
    end
    assert_select "div.fieldWithErrors" do |elements|
      assert elements.size == 2
    end
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, :id => groups(:one).id
    end

    assert_redirected_to groups_path
  end
end
