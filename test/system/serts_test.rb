require "application_system_test_case"

class SertsTest < ApplicationSystemTestCase
  setup do
    @sert = serts(:one)
  end

  test "visiting the index" do
    visit serts_url
    assert_selector "h1", text: "Serts"
  end

  test "creating a Sert" do
    visit serts_url
    click_on "New Sert"

    click_on "Create Sert"

    assert_text "Sert was successfully created"
    click_on "Back"
  end

  test "updating a Sert" do
    visit serts_url
    click_on "Edit", match: :first

    click_on "Update Sert"

    assert_text "Sert was successfully updated"
    click_on "Back"
  end

  test "destroying a Sert" do
    visit serts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sert was successfully destroyed"
  end
end
