RSpec.configure do |config|
  # request spec で sign_in が使える
  config.include Devise::Test::IntegrationHelpers, type: :request

  # controller spec で sign_in が使える
  config.include Devise::Test::ControllerHelpers, type: :controller
end