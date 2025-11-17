class SpotUpdateRequestsController < ApplicationController
  before_action :set_spot, only: [:select_type, :new, :create]

  def new
    @request_type = params[:type]
    @request = @spot.spot_update_requests.build

    # すべての店舗情報を事前に反映
    populate_request_from_spot

  end

  def create
    @request = @spot.spot_update_requests.build(spot_update_request_params)
    
    # デバッグ用：送信されたパラメータを確認
  Rails.logger.debug "=== 送信されたパラメータ ==="
  Rails.logger.debug spot_update_request_params.inspect
  
  # デバッグ用：保存前の@requestの値を確認
  Rails.logger.debug "=== 保存前の@requestの値 ==="
  Rails.logger.debug "child_chair: #{@request.child_chair}"
  Rails.logger.debug "bring_baby_food: #{@request.bring_baby_food}"
  Rails.logger.debug "child_menu: #{@request.child_menu}"
  
    if @request.save
      redirect_to @request.spot, notice: '修正依頼を送信しました'
    else
      flash.now[:alert] = "送信に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  # すべての店舗情報を事前に反映内容
  def populate_request_from_spot
  @request.assign_attributes(
    name: @spot.name,
    address: @spot.address,
    tel: @spot.tel,
    opening_hours: @spot.opening_hours,
    latitude: @spot.latitude,
    longitude: @spot.longitude,
    business_status: @spot.business_status,
    # 元データの値をそのまま反映（falseならfalse、trueならtrue）
    child_chair: @spot.child_chair || false,
    tatami_seat: @spot.tatami_seat || false,
    child_tableware: @spot.child_tableware || false,
    bring_baby_food: @spot.bring_baby_food || false,
    stroller_ok: @spot.stroller_ok || false,
    child_menu: @spot.child_menu || false,
    parking: @spot.parking || false,
    other_facility: @spot.other_facility || false,
    # デフォルトでpendingステータス
    status: :pending
  )
end

  # どのお店の修正依頼かセットする
  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  # お店の情報を修正依頼するパラメーター
  def spot_update_request_params
    params.require(:spot_update_request).permit(
      :name, :address, :tel, :opening_hours, :other_facility_comment,
      :latitude, :longitude, :business_status,
      # 子ども向け設備のパラメータ
      :child_chair, :tatami_seat, :child_tableware, :bring_baby_food,
      :stroller_ok, :child_menu, :parking, :other_facility,
      # 写真はSpotUpdateRequestImageで管理
    )
  end
end