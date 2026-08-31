require "test_helper"

class PwaSavesTest < ActionDispatch::IntegrationTest
  setup do
    Catalog::Importer.import!
  end

  test "manifest is standalone with stone colours" do
    get pwa_manifest_path(format: :json)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal I18n.t("app.name"), json["name"]
    assert_equal I18n.t("app.short_name"), json["short_name"]
    assert_equal "standalone", json["display"]
    assert_equal "/", json["start_url"]
    refute_equal "red", json["theme_color"]
    assert_equal "#fafaf9", json["theme_color"]
  end

  test "service worker is javascript without a live push listener" do
    get pwa_service_worker_path
    assert_response :success
    refute_match(/addEventListener\(\s*["']push["']/, response.body)
    assert_match(/Push stays off/, response.body)
  end

  test "saved page is public and empty without javascript" do
    get saved_path
    assert_response :success
    assert_select "#saved-index-empty"
    assert_select "#saved-index"
    assert_select "#catalog-disclaimer"
    assert_no_match(/sign in/i, response.body)
    assert_no_match(/log in/i, response.body)
  end

  test "compound show includes a save button" do
    get compound_path("bpc-157")
    assert_response :success
    assert_select "#compound-save-bpc-157"
    assert_select "#compound-save-bpc-157[aria-pressed=false]"
  end
end
