require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "requires a compound and provider" do
    product = Product.new(slug: "x", title_on_page: "X")
    refute product.valid?
    assert_includes product.errors[:compound], "must exist"
    assert_includes product.errors[:provider], "must exist"
  end
end
