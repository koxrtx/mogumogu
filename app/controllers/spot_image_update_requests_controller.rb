class SpotImageUpdateRequestsController < ApplicationController
  before_action :set_spot, only: [:new, :create ]

  def new
    # 修正タイプを取得
    @request_type = params[:type]
    @request = @spot.spot_image_update_requests.build

  end

  def create
    @request = @spot.spot_image_update_requests.build(spot_image_update_request_params)

    if @request.save
      redirect_to @request.spot, notice: '修正依頼を送信しました'
    else
      flash.now[:alert] = "送信に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end



  private


  # どのお店の修正依頼かセットする
  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  # お店の写真を修正依頼するパラメーター
  def spot_image_update_request_params
    params.require(:spot_image_update_request).permit(
      :request_type
    )
  end
end
