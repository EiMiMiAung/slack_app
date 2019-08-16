require 'test_helper'

class AllUnreadControllerTest < ActionDispatch::IntegrationTest
  test "should get allunread" do
    get all_unread_allunread_url
    assert_response :success
  end

end
