require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  
  # Index tests
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "index should have a new location link" do
    get :index
    assert_match new_location_path, @response.body
  end
  
  test "index provides link to view edit or destroy new location" do
    get :index
    locations = assigns(:locations)
    
    locations.each do |location|
      assert_match /<a href="#{location_path(location)}">Show/, @response.body
      assert_match /<a href="#{edit_location_path(location)}">Edit/, @response.body
      assert_match /<a href="#{location_path(location)}"(.+)>Destroy/, @response.body
    end
  end

  # new page tests
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

  # create tests
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
  
  test "create should fail with no address" do
    address = ""
    mock_geo(address,false)
    post :create, :location => {
      :name => "Booya",
      :address => address,
      :notes => "Fool!"
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
  
  test "create should fail with bad address" do
    address = "asd123gda$1"
    mock_geo(address, false)
    post :create, :location => {
      :name => "Booya",
      :address => address,
      :notes => "Sucka!"
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

  # show tests
  test "should show location" do
    get :show, :id => locations(:one).id
    assert_response :success
  end

  # edit tests
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

  # update tests
  test "should update location" do
    put :update, :id => locations(:one).id, :location => {
      :name => "SBC"
    }
    assert_redirected_to location_path(assigns(:location))
  end
  
  test "update should fail with no name" do
    put :update, :id => locations(:one).id, :location => {
      :name => ""
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
  
  test "update should pass with duplicate name but different address" do
    put :update, :id => locations(:one).id, :location => {
      :name => locations(:two).name
    }
    assert_redirected_to location_path(locations(:one).id)
  end
  
  test "update should fail with same name and address as other location" do
    address = locations(:two).address
    mock_geo(address)
    put :update, :id => locations(:one).id, :location => {
      :name => locations(:two).name,
      :address => locations(:two).address
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
  
  test "update should fail for stupid-long location notes" do
    put :update, :id => locations(:one).id, :location => {
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

  # destroy tests
  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, :id => locations(:one).id
    end

    assert_redirected_to locations_path
  end
end
