require "test_helper"

class CompoundsControllerTest < ActionDispatch::IntegrationTest
  setup { Catalog::Importer.import! }

  test "index is reachable" do
    get compounds_path
    assert_response :success
  end

  test "show is reachable" do
    get compound_path("bpc-157")
    assert_response :success
  end
end
