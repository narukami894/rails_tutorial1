require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'valid signup information' do
    get sign_up_path
    assert_difference 'User.count', 1 do
      post sign_up_path, params: { user: { name:  'Example User',
                                           email: 'user@example.com',
                                           password:              'password',
                                           password_confirmation: 'password' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert-success'
    assert is_logged_in?
  end

  test 'invalid sign_up information' do
    get sign_up_path
    assert_select 'form[action="/sign_up"]'
    assert_no_difference 'User.count' do
      post sign_up_path, params: { user: { name: '',
                                           email: 'user@invalid',
                                           password:              'foo',
                                           password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
end
