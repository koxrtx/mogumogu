class Admin::SpotsController < Admin::BaseController
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
end
