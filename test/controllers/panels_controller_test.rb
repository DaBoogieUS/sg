require 'test_helper'

class PanelsControllerTest < ActionController::TestCase
  setup do
    @panel = panels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:panels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create panel" do
    assert_difference('Panel.count') do
      post :create, panel: { buried: @panel.buried, deflector: @panel.deflector, door_height: @panel.door_height, door_inset_left: @panel.door_inset_left, door_width: @panel.door_width, height: @panel.height, is_assembled: @panel.is_assembled, is_manufactured: @panel.is_manufactured, panel_model_id: @panel.panel_model_id, side_position: @panel.side_position, structure_id: @panel.structure_id, width: @panel.width }
    end

    assert_redirected_to panel_path(assigns(:panel))
  end

  test "should show panel" do
    get :show, id: @panel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @panel
    assert_response :success
  end

  test "should update panel" do
    patch :update, id: @panel, panel: { buried: @panel.buried, deflector: @panel.deflector, door_height: @panel.door_height, door_inset_left: @panel.door_inset_left, door_width: @panel.door_width, height: @panel.height, is_assembled: @panel.is_assembled, is_manufactured: @panel.is_manufactured, panel_model_id: @panel.panel_model_id, side_position: @panel.side_position, structure_id: @panel.structure_id, width: @panel.width }
    assert_redirected_to panel_path(assigns(:panel))
  end

  test "should destroy panel" do
    assert_difference('Panel.count', -1) do
      delete :destroy, id: @panel
    end

    assert_redirected_to panels_path
  end
end
