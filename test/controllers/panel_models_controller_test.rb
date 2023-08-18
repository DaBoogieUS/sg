require 'test_helper'

class PanelModelsControllerTest < ActionController::TestCase
  setup do
    @panel_model = panel_models(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:panel_models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create panel_model" do
    assert_difference('PanelModel.count') do
      post :create, panel_model: { name: @panel_model.name }
    end

    assert_redirected_to panel_model_path(assigns(:panel_model))
  end

  test "should show panel_model" do
    get :show, id: @panel_model
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @panel_model
    assert_response :success
  end

  test "should update panel_model" do
    patch :update, id: @panel_model, panel_model: { name: @panel_model.name }
    assert_redirected_to panel_model_path(assigns(:panel_model))
  end

  test "should destroy panel_model" do
    assert_difference('PanelModel.count', -1) do
      delete :destroy, id: @panel_model
    end

    assert_redirected_to panel_models_path
  end
end
