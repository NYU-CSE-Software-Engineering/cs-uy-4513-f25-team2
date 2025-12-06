SimpleCov.start "rails" do
  # Branch coverage shows which branches of conditionals are actually tested.
  enable_coverage :branch
  primary_coverage :branch

  # Track all Ruby files in app/ and lib/, even if they are not loaded yet.
  track_files "{app,lib}/**/*.rb"

  # Filters: ignore non-application files from coverage percents.
  add_filter "/bin/"
  add_filter "/db/"
  add_filter "/config/"
  add_filter "/spec/"
  add_filter "/features/"
  add_filter "/vendor/"

  # Coverage groups (sidebar sections in HTML report).
  add_group "Models",      "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers",     "app/helpers"
  add_group "Jobs",        "app/jobs"
  add_group "Mailers",     "app/mailers"
  add_group "Libraries",   "lib"

  # Merge timeout: allow enough time for RSpec and Cucumber to both run and
  # be merged into a single coverage report.
  merge_timeout 3600 # seconds (1 hour)

  # Enforce minimum coverage.
  # Project requirement: around 80% combined RSpec + Cucumber coverage.
  minimum_coverage 80

  # Per-file guardrail so we don't have files sitting at 0% while overall
  # coverage looks healthy.
  minimum_coverage_by_file 60
end