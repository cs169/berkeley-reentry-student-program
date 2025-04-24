# frozen_string_literal: true

# Rails 7.1+废弃警告修复
# 处理从TestFixtures.fixture_path=迁移到TestFixtures.fixture_paths=的情况

module FixturePathsHelper
  def update_fixture_paths(path)
    # 如果ActiveRecord::TestFixtures响应fixture_paths=方法(Rails 7.1+)
    if ActiveRecord::TestFixtures.respond_to?(:fixture_paths=)
      ActiveRecord::TestFixtures.fixture_paths = [path]
    else
      # 旧的方法(向后兼容)
      ActiveRecord::TestFixtures.fixture_path = path
    end
  end
end

# 在RSpec配置中包含这个帮助方法
RSpec.configure do |config|
  config.extend FixturePathsHelper
end
