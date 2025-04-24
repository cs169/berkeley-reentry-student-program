# frozen_string_literal: true

# 统一常量定义以避免重复定义和警告
module TestConstants
  # 学生测试凭据
  STUDENT_CREDENTIALS = {
    "provider" => "google_oauth2",
    "uid" => "1000000000",
    "info" => {
      "name" => "Google Test Developer",
      "email" => "google_student@berkeley.edu",
      "first_name" => "Google",
      "last_name" => "Test Developer"
    },
    "credentials" => {
      "token" => "credentials_token_1234567",
      "refresh_token" => "credentials_refresh_token_45678"
    }
  }.freeze
end

# 在RSpec配置中包含此模块，使常量全局可用
RSpec.configure do |config|
  config.include TestConstants
end
