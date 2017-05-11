require 'test_helper'

class UsersLogInTest < ActionDispatch::IntegrationTest
  test 'login with invalid information' do
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
