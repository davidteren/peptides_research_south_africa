require "test_helper"

class ProviderTest < ActiveSupport::TestCase
  test "requires a slug and name" do
    provider = Provider.new
    refute provider.valid?
    assert_includes provider.errors[:slug], "can't be blank"
    assert_includes provider.errors[:name], "can't be blank"
  end
end
