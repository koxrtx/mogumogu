class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録時に :name を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # アカウント編集時にも許可したい場合
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
