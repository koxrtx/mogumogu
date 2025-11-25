class SpotsController < ApplicationController
  def new
    @spot = Spot.new
  end

  # 詳細
  def show
    @spot = Spot.find(params[:id])
  end

  # 投稿
  def create
    @spot = current_user.spots.build(spot_params)

    if @spot.save
      flash[:thanks] = true
      redirect_to @spot
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  # お店の情報を投稿するパラメーター
  def spot_params
    params.require(:spot).permit(
      :name, :address, :tel, :opening_hours, :other_facility_comment,
      :latitude, :longitude, :business_status,
      # 子ども向け設備のパラメータ
      :child_chair, :tatami_seat, :child_tableware, :bring_baby_food,
      :stroller_ok, :child_menu, :parking, :other_facility,
      # 複数ファイル 単一なら:image
      images: []
    )
  end
end
