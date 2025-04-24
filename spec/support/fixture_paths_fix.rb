# frozen_string_literal: true

# Fix for Rails 7.1+ deprecation warning
# Handle migration from TestFixtures.fixture_path= to TestFixtures.fixture_paths=

module FixturePathsHelper
  def update_fixture_paths(path)
    # If ActiveRecord::TestFixtures responds to fixture_paths= method (Rails 7.1+)
    if ActiveRecord::TestFixtures.respond_to?(:fixture_paths=)
      ActiveRecord::TestFixtures.fixture_paths = [path]
    else
      # Older method (for backward compatibility)
      ActiveRecord::TestFixtures.fixture_path = path
    end
  end
end

# Include this helper method in RSpec configuration
RSpec.configure do |config|
  config.extend FixturePathsHelper
end
