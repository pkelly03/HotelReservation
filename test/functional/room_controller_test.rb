require File.dirname(__FILE__) + '/../test_helper'
require 'room_controller'

# Re-raise errors caught by the controller.
class RoomController; def rescue_action(e) raise e end; end

class RoomControllerTest < Test::Unit::TestCase
  fixtures :rooms

  def setup
    @controller = RoomController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = rooms(:first).id
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

    assert_not_nil assigns(:rooms)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:room)
    assert assigns(:room).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:room)
  end

  def test_create
    num_rooms = Room.count

    post :create, :room => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_rooms + 1, Room.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:room)
    assert assigns(:room).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Room.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Room.find(@first_id)
    }
  end
end
