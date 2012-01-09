require File.dirname(__FILE__) + '/../test_helper'
require 'anothercontroller_controller'

# Re-raise errors caught by the controller.
class AnothercontrollerController; def rescue_action(e) raise e end; end

class AnothercontrollerControllerTest < Test::Unit::TestCase
  fixtures :another_models

  def setup
    @controller = AnothercontrollerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = another_models(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:another_models)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:another_model)
    assert assigns(:another_model).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:another_model)
  end

  def test_create
    num_another_models = AnotherModel.count

    post :create, :another_model => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_another_models + 1, AnotherModel.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:another_model)
    assert assigns(:another_model).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      AnotherModel.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      AnotherModel.find(@first_id)
    }
  end
end
