require 'test_helper'

class SubscribtionsControllerTest < ActionController::TestCase
  setup do
    @subscribtion = subscribtions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subscribtions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subscribtion" do
    assert_difference('Subscribtion.count') do
      post :create, subscribtion: { by_email: @subscribtion.by_email, email_period: @subscribtion.email_period, filter: @subscribtion.filter, user_id: @subscribtion.user_id }
    end

    assert_redirected_to subscribtion_path(assigns(:subscribtion))
  end

  test "should show subscribtion" do
    get :show, id: @subscribtion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subscribtion
    assert_response :success
  end

  test "should update subscribtion" do
    put :update, id: @subscribtion, subscribtion: { by_email: @subscribtion.by_email, email_period: @subscribtion.email_period, filter: @subscribtion.filter, user_id: @subscribtion.user_id }
    assert_redirected_to subscribtion_path(assigns(:subscribtion))
  end

  test "should destroy subscribtion" do
    assert_difference('Subscribtion.count', -1) do
      delete :destroy, id: @subscribtion
    end

    assert_redirected_to subscribtions_path
  end
end
