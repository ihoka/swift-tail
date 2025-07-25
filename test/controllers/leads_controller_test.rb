require "test_helper"
require "minitest/mock"

class LeadsControllerTest < ActionDispatch::IntegrationTest
  test "should create lead and send email" do
    # Mock the mailer to verify it's called
    mock_mailer = Minitest::Mock.new
    mock_mailer.expect :call, nil, [ Lead ]

    EnveloopMailer.stub :new_lead_email, mock_mailer do
      post leads_path, params: {
        lead: {
          from: "New York",
          to: "Los Angeles",
          email: "test@example.com",
          phone: "+1 (555) 123-4567"
        }
      }
    end

    assert_redirected_to root_path
    assert_equal "Thank you! We'll be in touch soon.", flash[:notice]

    # Verify lead was created
    lead = Lead.last
    assert_equal "New York", lead.from
    assert_equal "Los Angeles", lead.to
    assert_equal "test@example.com", lead.email
    assert_equal "+1 (555) 123-4567", lead.phone

    # Verify mock was called
    mock_mailer.verify
  end

  test "should handle validation errors and not send email" do
    # Mock the mailer to verify it's NOT called
    mock_mailer = Minitest::Mock.new
    # Don't set up any expectations since it shouldn't be called

    initial_count = Lead.count

    EnveloopMailer.stub :new_lead_email, mock_mailer do
      post leads_path, params: {
        lead: {
          from: "",
          to: "",
          email: "",
          phone: ""
        }
      }
    end

    assert_redirected_to root_path
    assert_equal "Please fill in all required fields.", flash[:alert]

    # Verify no lead was created
    assert_equal initial_count, Lead.count

    # Mock should not have been called, so verify will pass
    mock_mailer.verify
  end
end
