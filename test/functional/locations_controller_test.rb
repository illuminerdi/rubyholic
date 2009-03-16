require 'test_helper'
require 'flexmock/test_unit'

class LocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[address]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'location[notes]'
    }
    
    assert ! @response.body.include?('location[latitude]')
    assert ! @response.body.include?('location[longitude]')
  end

  test "should create location" do
    address = "1215 4th Ave, Seattle, WA 98101"
    mock_geo(address)
    assert_difference('Location.count') do
      post :create, :location => {
        :name => "Cafe Migliore",
        :address => address,
        :notes => "Large meeting table and comfortable benches. Good coffee made...okay. Nice waitstaff. Big screen television is a bit of a distraction."
      }
    end

    assert_redirected_to location_path(assigns(:location))
  end
  
  test "should fail without name" do
    address = "1215 4th Ave, Seattle, WA 98101"
    mock_geo(address)
    post :create, :location => {
        :name => "",
        :address => address,
        :notes => "Large meeting table and comfortable benches. Good coffee made...okay. Nice waitstaff. Big screen television is a bit of a distraction."
    }
    
    assert_response :success
    location = assigns(:location)
    assert ! location.valid?
    assert_equal 1, location.errors.size
    error_msgs = location.errors.full_messages
    error_msgs.each do |error_msg|
      assert_match error_msg, @response.body
    end
    assert_select "div.fieldWithErrors" do |elements|
      assert_equal 2, elements.size
    end
  end
  
  test "should not fail with duplicate name but different address" do
    address = "1215 4th Ave, Seattle, WA 98101"
    mock_geo(address)
    post :create, :location => {
        :name => locations(:one).name,
        :address => address,
        :notes => ""
    }
    
    assert_redirected_to location_path(assigns(:location))
  end
  
  test "should fail with duplicate name and address combo" do
    address = locations(:one).address
    mock_geo(address)
    post :create, :location => {
        :name => locations(:one).name,
        :address => address,
        :notes => ""
    }
    
    assert_response :success
    location = assigns(:location)
    assert ! location.valid?
    assert_equal 1, location.errors.size
    error_msgs = location.errors.full_messages
    error_msgs.each do |error_msg|
      assert_match error_msg, @response.body
    end
    assert_select "div.fieldWithErrors" do |elements|
      assert_equal 2, elements.size
    end
  end
  
  test "should fail with super-long notes" do
    address = "1215 4th Ave, Seattle, WA 98101"
    mock_geo(address)
    post :create, :location => {
        :name => "Migliore",
        :address => address,
        :notes => (0..26).map {|i| i.to_s * 72}.to_s
    }
    
    assert_response :success
    location = assigns(:location)
    assert ! location.valid?
    assert_equal 1, location.errors.size
    error_msgs = location.errors.full_messages
    error_msgs.each do |error_msg|
      assert_match error_msg, @response.body
    end
    assert_select "div.fieldWithErrors" do |elements|
      assert_equal 2, elements.size
    end
  end

  test "should show location" do
    get :show, :id => locations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => locations(:one).id
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[address]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'location[notes]'
    }
    
    assert ! @response.body.include?('location[latitude]')
    assert ! @response.body.include?('location[longitude]')
  end

  test "should update location" do
    put :update, :id => locations(:one).id, :location => {
      :name => "SBC"
    }
    assert_redirected_to location_path(assigns(:location))
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, :id => locations(:one).id
    end

    assert_redirected_to locations_path
  end
end
