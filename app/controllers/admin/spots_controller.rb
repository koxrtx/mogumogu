class Admin::SpotsController < ApplicationController
  # ユーザーがログインしているか
  before_action :authenticate_user!
  # 管理者か確認
  before_action :admin_required
  # 対象店舗
  before_action :set_spot, only: [:show, :destroy]

  # 一覧
  def index
    @spots = Spot.all
    # 検索機能
    if params[:search].present?
      @spots = @spots.where("name ILIKE ? OR address ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    @spots = @spots.page(params[:page]).per(20)
  end

  def show
  end

  # 削除
  def destroy
    @spot.destroy
    redirect_to admin_spots_path, notice: '店舗情報を削除しました'
  end

  private

  def set_spot
    @spot = Spot.find(params[:id])
  end

  def admin_required
    redirect_to root_path unless current_user.admin?
  end
end
