require 'test_helper'

class NestRunsControllerTest < ActionController::TestCase
  setup do
    @nest_run = nest_runs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nest_runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nest_run" do
    assert_difference('NestRun.count') do
      post :create, nest_run: { manufacturing_job_id: @nest_run.manufacturing_job_id, material_id: @nest_run.material_id }
    end

    assert_redirected_to nest_run_path(assigns(:nest_run))
  end

  test "should show nest_run" do
    get :show, id: @nest_run
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nest_run
    assert_response :success
  end

  test "should update nest_run" do
    patch :update, id: @nest_run, nest_run: { manufacturing_job_id: @nest_run.manufacturing_job_id, material_id: @nest_run.material_id }
    assert_redirected_to nest_run_path(assigns(:nest_run))
  end

  test "should destroy nest_run" do
    assert_difference('NestRun.count', -1) do
      delete :destroy, id: @nest_run
    end

    assert_redirected_to nest_runs_path
  end
end
