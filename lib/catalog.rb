# Frozen catalog JSON under data/. Agents update files; Rails reads them.
module Catalog
  DATA_ROOT = Rails.root.join("data")
  RECORD_DIRS = {
    "compound" => "compounds",
    "provider" => "providers",
    "product" => "products"
  }.freeze
end
