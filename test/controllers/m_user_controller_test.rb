require 'test_helper'

class MUserControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get m_user_new_url
    assert_response :success
  end

  test "should get create" do
    get m_user_create_url
    assert_response :success
  end

end
