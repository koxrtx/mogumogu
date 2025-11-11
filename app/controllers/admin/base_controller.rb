class Admin::BaseController < ApplicationController
  # Admin::〇〇Controller が継承する共通クラス
  # ユーザーがログインしているか
  before_action :authenticate_user!
  before_action :admin_required

  private
  # 管理者か確認
  def admin_required
    redirect_to root_path unless current_user.admin?
  end
  
  # ユーザー情報を取得
  def set_user
    @user = User.find(params[:id])
  end

  # 店舗情報を取得
  def set_spot
    @spot = Spot.find(params[:id])
  end

  # 問い合わせ情報取得
  def set_inquiry
    @inquiry = Inquiry.find(params[:id])
  end
end