namespace :catalog do
  desc "Fail if catalog JSON is invalid, missing a review date, or has empty sources"
  task check: :environment do
    result = Catalog::Validator.check
    if result.ok
      puts "Catalog JSON is valid."
    else
      warn result.errors.join("\n")
      abort "Catalog JSON failed the merge check."
    end
  end

  desc "Load valid catalog JSON into PostgreSQL"
  task import: :environment do
    Catalog::Importer.import!
    puts "Imported #{Compound.count} compounds, #{Provider.count} providers, #{Product.count} products."
  end
end
