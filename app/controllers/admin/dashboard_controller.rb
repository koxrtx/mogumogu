class Admin::DashboardController < ApplicationController
  # ユーザーがログインしているか
  before_action :authenticate_user!
  # 管理者か
  before_action :admin_required
  def index
  end

  def admin_required
    redirect_to root_path unless current_user.admin?
  end
end
