require "test_helper"

class CompoundTest < ActiveSupport::TestCase
  test "requires a slug and name" do
    compound = Compound.new
    refute compound.valid?
    assert_includes compound.errors[:slug], "can't be blank"
    assert_includes compound.errors[:name], "can't be blank"
  end
end
