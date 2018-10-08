require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    
    #以下　演習問題でslack情報より一旦削除したが　test通ったので復活
    get contact_path                              #演習問題
    assert_select "title", full_title("Contact")  #演習問題
    get signup_path                               #演習問題
    assert_select "title", full_title("Sign up")  #演習問題
  end
  
  #以下　演習問題10.3.1.1 ログイン済みユーザーとそうでないユーザーのそれぞれに対して、正しい振る舞い
  def setup
    @user       = users(:michael)
  end
  
  test "layout links when logged in" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)    
    assert_select "a[href=?]", logout_path
  end
  
  
end
