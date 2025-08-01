require "test_helper"

class LeadTest < ActiveSupport::TestCase
  test "should create lead with factory" do
    lead = create(:lead)
    assert lead.persisted?
    assert lead.valid?
  end

  test "should validate presence of from" do
    lead = build(:lead, from: nil)
    refute lead.valid?
    assert_includes lead.errors[:from], "can't be blank"
  end

  test "should validate presence of to" do
    lead = build(:lead, to: nil)
    refute lead.valid?
    assert_includes lead.errors[:to], "can't be blank"
  end

  test "should validate presence of email" do
    lead = build(:lead, email: nil)
    refute lead.valid?
    assert_includes lead.errors[:email], "can't be blank"
  end

  test "should validate email format" do
    lead = build(:lead, email: "invalid_email")
    refute lead.valid?
    assert_includes lead.errors[:email], "is invalid"
  end

  test "should validate presence of phone" do
    lead = build(:lead, phone: nil)
    refute lead.valid?
    assert_includes lead.errors[:phone], "can't be blank"
  end
end
