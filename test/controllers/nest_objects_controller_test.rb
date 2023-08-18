require 'test_helper'

class NestObjectsControllerTest < ActionController::TestCase
  setup do
    @nest_object = nest_objects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nest_objects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nest_object" do
    assert_difference('NestObject.count') do
      post :create, nest_object: { nest_id: @nest_object.nest_id, part_id: @nest_object.part_id, x: @nest_object.x, y: @nest_object.y }
    end

    assert_redirected_to nest_object_path(assigns(:nest_object))
  end

  test "should show nest_object" do
    get :show, id: @nest_object
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nest_object
    assert_response :success
  end

  test "should update nest_object" do
    patch :update, id: @nest_object, nest_object: { nest_id: @nest_object.nest_id, part_id: @nest_object.part_id, x: @nest_object.x, y: @nest_object.y }
    assert_redirected_to nest_object_path(assigns(:nest_object))
  end

  test "should destroy nest_object" do
    assert_difference('NestObject.count', -1) do
      delete :destroy, id: @nest_object
    end

    assert_redirected_to nest_objects_path
  end
end
