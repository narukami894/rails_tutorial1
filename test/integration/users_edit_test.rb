require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:hoge)
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert_nil session[:forwarding_url]
    new_name  = 'Foo Bar'
    new_email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name:  new_name,
                                              email: new_email,
                                              password:              '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal new_name,  @user.name
    assert_equal new_email, @user.email
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  '',
                                              email: 'foo@invalid',
                                              password:              'foo',
                                              password_confirmation: 'bar' } }

    assert_select 'div#error_explanation li', count: 4
    assert_template 'users/edit'
  end
end
