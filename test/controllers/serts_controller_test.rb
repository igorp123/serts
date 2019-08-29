require 'test_helper'

class SertsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sert = serts(:one)
  end

  test "should get index" do
    get serts_url
    assert_response :success
  end

  test "should get new" do
    get new_sert_url
    assert_response :success
  end

  test "should create sert" do
    assert_difference('Sert.count') do
      post serts_url, params: { sert: {  } }
    end

    assert_redirected_to sert_url(Sert.last)
  end

  test "should show sert" do
    get sert_url(@sert)
    assert_response :success
  end

  test "should get edit" do
    get edit_sert_url(@sert)
    assert_response :success
  end

  test "should update sert" do
    patch sert_url(@sert), params: { sert: {  } }
    assert_redirected_to sert_url(@sert)
  end

  test "should destroy sert" do
    assert_difference('Sert.count', -1) do
      delete sert_url(@sert)
    end

    assert_redirected_to serts_url
  end
end
