require 'test_helper'

class NestsControllerTest < ActionController::TestCase
  setup do
    @nest = nests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nest" do
    assert_difference('Nest.count') do
      post :create, nest: { nest_run_id: @nest.nest_run_id }
    end

    assert_redirected_to nest_path(assigns(:nest))
  end

  test "should show nest" do
    get :show, id: @nest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nest
    assert_response :success
  end

  test "should update nest" do
    patch :update, id: @nest, nest: { nest_run_id: @nest.nest_run_id }
    assert_redirected_to nest_path(assigns(:nest))
  end

  test "should destroy nest" do
    assert_difference('Nest.count', -1) do
      delete :destroy, id: @nest
    end

    assert_redirected_to nests_path
  end
end
