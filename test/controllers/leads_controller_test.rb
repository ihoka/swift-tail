require "test_helper"
require "minitest/mock"

class LeadsControllerTest < ActionDispatch::IntegrationTest
  test "should create lead and send email" do
    # Mock the mailer to verify it's called
    mock_mailer = Minitest::Mock.new
    mock_mailer.expect :call, nil, [ Lead ]

    lead_attributes = attributes_for(:lead)

    EnveloopMailer.stub :new_lead_email, mock_mailer do
      post leads_path, params: { lead: lead_attributes }
    end

    assert_redirected_to root_path
    assert_equal "Thank you! We'll be in touch soon.", flash[:notice]

    # Verify lead was created
    lead = Lead.last
    assert_equal lead_attributes[:from], lead.from
    assert_equal lead_attributes[:to], lead.to
    assert_equal lead_attributes[:email], lead.email
    assert_equal lead_attributes[:phone], lead.phone

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
