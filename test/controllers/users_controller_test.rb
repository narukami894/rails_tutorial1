require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:hoge)
    @another_user = users(:piyo)
  end

  test 'should get new' do
    get sign_up_path
    assert_response :success
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to log_in_url
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to log_in_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to log_in_url
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@another_user)
    assert_not @another_user.admin?
    patch user_path(@another_user), params: {
      user: { password:              'password',
              password_confirmation: 'password',
              admin: true }
    }
    assert_not @another_user.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@another_user)
    end
    assert_redirected_to log_in_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@another_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test 'should redirect following when not logged in' do
    get following_user_path(@user)
    assert_redirected_to log_in_url
  end

  test 'should redirect followers when not logged in' do
    get followers_user_path(@user)
    assert_redirected_to log_in_url
  end
end
