require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Jake Bruemmer", email: "jake@example.com", password: "minimum", password_confirmation: "minimum")
  end

  test "should save user" do
    assert @user.save
  end

  test "user password should be 6 characters" do
    @user.password = @user.password_confirmation = "a"
    assert_not @user.valid?
  end

  test "user password should be non blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "user should have valid email" do
    @user.email = "a"
    assert_not @user.valid?
  end
end
