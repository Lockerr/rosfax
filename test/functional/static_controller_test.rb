require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "should get google_validation" do
    get :google_validation
    assert_response :success
  end

end
