require "test_helper"

class ProvidersControllerTest < ActionDispatch::IntegrationTest
  setup { Catalog::Importer.import! }

  test "index is reachable" do
    get providers_path
    assert_response :success
  end

  test "show is reachable" do
    get provider_path("reschem")
    assert_response :success
  end
end
