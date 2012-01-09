require File.dirname(__FILE__) + '/../test_helper'
require 'scaffold_controller'

# Re-raise errors caught by the controller.
class ScaffoldController; def rescue_action(e) raise e end; end

class ScaffoldControllerTest < Test::Unit::TestCase
  def setup
    @controller = ScaffoldController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
