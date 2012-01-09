require File.dirname(__FILE__) + '/../test_helper'
require 'test1_controller'

# Re-raise errors caught by the controller.
class Test1Controller; def rescue_action(e) raise e end; end

class Test1ControllerTest < Test::Unit::TestCase
  fixtures :test1s

  def setup
    @controller = Test1Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = test1s(:first).id
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

    assert_not_nil assigns(:test1s)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:test1)
    assert assigns(:test1).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:test1)
  end

  def test_create
    num_test1s = Test1.count

    post :create, :test1 => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_test1s + 1, Test1.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:test1)
    assert assigns(:test1).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Test1.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Test1.find(@first_id)
    }
  end
end
