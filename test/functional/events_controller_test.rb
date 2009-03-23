require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  
  # events index tests
  test "should get index" do
    get :index
    assert_response :success
    events = assigns(:events)
    assert_not_nil events
  end

  # new event tests
  test "should get new" do
    get :new
    assert_response :success
    
    assert_tag :tag => 'input', :attributes => {
      :name => 'event[name]'
    }
    assert_tag :tag => 'select', :attributes => {
      :name => 'event[group_id]'
    }
    assert_tag :tag => 'select', :attributes => {
      :name => 'event[location_id]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'event[description]'
    }
    (1..3).each do |x|
      assert_tag :tag => 'select', :attributes => {
        :name => "event[start_date(#{x}i)]"
      }
      assert_tag :tag => 'select', :attributes => {
        :name => "event[end_date(#{x}i)]"
      }
    end
  end
  
  test "should show select list of available groups" do
    get :new
    groups = assigns(:groups)
    groups.each do |group|
      assert_match /<option value="#{group.id}"/, @response.body
    end
  end
  
  test "should show select list of available locations" do
    get :new
    locations = assigns(:locations)
    locations.each do |location|
      assert_match /<option value="#{location.id}"/, @response.body
    end
  end

  # create event tests
  test "should create event" do
    assert_difference('Event.count') do
      post :create, :event => {
        :name => "controller test event",
        :description => "This is a test event for controller testing.",
        :group_id => groups(:one).id,
        :location_id => locations(:two).id,
        :start_date => "2009-06-05",
        :end_date => "2009-06-05"
      }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  # show event tests
  test "should show event" do
    get :show, :id => events(:one).id
    assert_response :success
  end

  # edit event tests
  test "should get edit" do
    get :edit, :id => events(:one).id
    assert_response :success
    
    assert_tag :tag => 'input', :attributes => {
      :name => 'event[name]'
    }
    assert_tag :tag => 'select', :attributes => {
      :name => 'event[group_id]'
    }
    assert_tag :tag => 'select', :attributes => {
      :name => 'event[location_id]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'event[description]'
    }
    (1..3).each do |x|
      assert_tag :tag => 'select', :attributes => {
        :name => "event[start_date(#{x}i)]"
      }
      assert_tag :tag => 'select', :attributes => {
        :name => "event[end_date(#{x}i)]"
      }
    end
  end
  
  test "should show select list of groups with chosen group selected" do
    get :edit, :id => events(:one).id
    groups = assigns(:groups)
    event = assigns(:event)
    groups.each do |group|
      assert_match /<option value="#{group.id}"/, @response.body
    end
    assert_match /<option value="#{event.group.id}" selected/, @response.body
  end
  
  test "should show select list of locations with chosen location selected" do
    get :edit, :id => events(:one).id
    locations = assigns(:locations)
    event = assigns(:event)
    locations.each do |location|
      assert_match /<option value="#{location.id}"/, @response.body
    end
    assert_match /<option value="#{event.location.id}" selected/, @response.body
  end

  # update event tests
  test "should update event" do
    put :update, :id => events(:one).id, :event => { }
    
    assert_redirected_to event_path(assigns(:event))
  end

  # destroy event tests
  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, :id => events(:one).id
    end

    assert_redirected_to events_path
  end
end
