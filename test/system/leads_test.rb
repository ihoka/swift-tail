require "application_system_test_case"

class LeadsTest < ApplicationSystemTestCase
  test "submitting a lead form creates a lead in the database" do
    visit root_path

    # Verify the form is present
    assert_text "Get Empty Leg Alerts"

    # Count leads before submission
    initial_count = Lead.count

    # Fill out the form
    fill_in "From", with: "New York"
    fill_in "To", with: "Los Angeles"
    fill_in "Email", with: "test@example.com"
    fill_in "Phone", with: "+1 (555) 123-4567"

    # Submit the form
    click_button "Get Alerts"

    # Wait for redirect and verify lead was created
    assert_current_path root_path
    assert_equal initial_count + 1, Lead.count

    # Verify the lead was created with correct data
    lead = Lead.last
    assert_equal "New York", lead.from
    assert_equal "Los Angeles", lead.to
    assert_equal "test@example.com", lead.email
    assert_equal "+1 (555) 123-4567", lead.phone

    # Verify success message
    assert_text "Thank you! We'll be in touch soon."
  end

  test "form submission with missing fields shows error" do
    visit root_path

    # Count leads before submission
    initial_count = Lead.count

    # Submit form without filling any fields
    click_button "Get Alerts"

    # Wait for redirect and verify no lead was created
    assert_current_path root_path
    assert_equal initial_count, Lead.count

    # Verify error message
    assert_text "Please fill in all required fields."
  end

  test "form fields are properly labeled and styled" do
    visit root_path

    # Check form structure and styling
    assert_selector "form"
    assert_selector "input[name='lead[from]']"
    assert_selector "input[name='lead[to]']"
    assert_selector "input[name='lead[email]'][type='email']"
    assert_selector "input[name='lead[phone]'][type='tel']"
    assert_selector "input[type='submit'][value='Get Alerts']"

    # Check labels
    assert_text "From"
    assert_text "To"
    assert_text "Email"
    assert_text "Phone"
  end
end
