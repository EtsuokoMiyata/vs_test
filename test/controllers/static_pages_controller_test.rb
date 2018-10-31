require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Figure Skating App"
  end
  
   
  
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Figure Skating App"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "お気に入り | #{@base_title}"
  end
  
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end 
  
   test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "管理人 | Figure Skating App"
  end

end
