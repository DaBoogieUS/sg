require 'test_helper'

class ManufacturingJobsControllerTest < ActionController::TestCase
  setup do
    @manufacturing_job = manufacturing_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manufacturing_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manufacturing_job" do
    assert_difference('ManufacturingJob.count') do
      post :create, manufacturing_job: { date: @manufacturing_job.date, name: @manufacturing_job.name, phase_id: @manufacturing_job.phase_id }
    end

    assert_redirected_to manufacturing_job_path(assigns(:manufacturing_job))
  end

  test "should show manufacturing_job" do
    get :show, id: @manufacturing_job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manufacturing_job
    assert_response :success
  end

  test "should update manufacturing_job" do
    patch :update, id: @manufacturing_job, manufacturing_job: { date: @manufacturing_job.date, name: @manufacturing_job.name, phase_id: @manufacturing_job.phase_id }
    assert_redirected_to manufacturing_job_path(assigns(:manufacturing_job))
  end

  test "should destroy manufacturing_job" do
    assert_difference('ManufacturingJob.count', -1) do
      delete :destroy, id: @manufacturing_job
    end

    assert_redirected_to manufacturing_jobs_path
  end
end
