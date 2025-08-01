require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should create user with factory" do
    user = create(:user)
    assert user.persisted?
    assert user.valid?
  end

  test "should validate presence of name" do
    user = build(:user, name: nil)
    refute user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "should validate presence of email" do
    user = build(:user, email: nil)
    refute user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "should validate uniqueness of email" do
    create(:user, email: "test@example.com")
    user = build(:user, email: "test@example.com")
    refute user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end
end
