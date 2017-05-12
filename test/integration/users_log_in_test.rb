require 'test_helper'

class UsersLogInTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:hoge)
  end

  test 'log_in with valid information' do
    get log_in_path
    assert_template 'sessions/new'
    post log_in_path, params: { session: { email: @user.email,
                                           password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', log_in_path, count: 0
    assert_select 'a[href=?]', log_out_path
    assert_select 'a[href=?]', user_path(@user)
    delete log_out_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'a[href=?]', log_in_path
    assert_select 'a[href=?]', log_out_path,     count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'log_in with invalid information' do
    get log_in_path
    assert_template 'sessions/new'
    post log_in_path, params: { session: { email: 'hoge@fuga',
                                           password: 'piyo' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select 'div.alert-danger'
    get root_path
    assert flash.empty?
  end
end
