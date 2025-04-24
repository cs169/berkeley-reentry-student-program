# frozen_string_literal: true

# Configure ActionText
Rails.application.configure do
  # Ensure ActionText assets are precompiled
  config.assets.precompile += %w(
    actiontext.css
    trix.css
    trix.js
    actiontext.js
    controllers/index.js
    controllers/application.js
  )
end

# Ensure the correct attachment processor is set for ActionText
# Use in-memory storage in test or CI environments to speed up tests
if Rails.env.test?
  Rails.application.config.active_storage.service = :test
end
