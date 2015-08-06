require 'test_helper'

class WorkHistoriesControllerTest < ActionController::TestCase
  setup do
    @work_history = work_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:work_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work_history" do
    assert_difference('WorkHistory.count') do
      post :create, work_history: { resume_id: @work_history.resume_id }
    end

    assert_redirected_to work_history_path(assigns(:work_history))
  end

  test "should show work_history" do
    get :show, id: @work_history
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @work_history
    assert_response :success
  end

  test "should update work_history" do
    patch :update, id: @work_history, work_history: { resume_id: @work_history.resume_id }
    assert_redirected_to work_history_path(assigns(:work_history))
  end

  test "should destroy work_history" do
    assert_difference('WorkHistory.count', -1) do
      delete :destroy, id: @work_history
    end

    assert_redirected_to work_histories_path
  end
end
