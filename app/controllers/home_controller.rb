class HomeController < ApplicationController

  def index
    @q = Spot.active.ransack(params[:q])
    base_spots = @q.result(distinct: true)

    if params[:q].present?
      # 位置情報がある場合は距離順でソート
      if params[:latitude].present? && params[:longitude].present?
        latitude = params[:latitude].to_f
        longitude = params[:longitude].to_f

        # 10km圏内で距離順に並び替え
        @spots = base_spots.near([latitude, longitude], 10).limit(10)
      else
        # 位置情報がない場合は通常の並び順
        @spots = base_spots.limit(10)
      end
    else
      # 検索パラメータがない場合も@spotsを初期化
      @spots = Spot.none
    end
  end

  def search
    # パラメータの検証・サニタイズ
    query = params.dig(:q, :name_or_address_cont).to_s.strip
    latitude = params[:latitude]&.to_f
    longitude = params[:longitude]&.to_f


    Rails.logger.info "Search params: #{params.inspect}"
    Rails.logger.info "Extracted query: #{query}"


    if query.blank?
      render json: []
      return
    end

    # データベースから営業店のみのデータを取得
    spots = Spot.active.where("name ILIKE ? OR address ILIKE ?", "%#{query}%", "%#{query}%")

    if latitude.present? && longitude.present?
      spots = spots.near([latitude, longitude], 10).limit(10)
    else
      spots = spots.limit(10).order(:name)
    end

    # データを整形してJSONで返す
    results = spots.map do |spot|
    label = if spot.name.include?(query)
      spot.name
    elsif spot.address.include?(query)
      spot.address
    else
      "#{spot.name} - #{spot.address}"
    end

    result = {
      label: label,
      value: label
    }

    # 距離情報を追加
      if latitude.present? && longitude.present? && spot.latitude.present?
        distance = Geocoder::Calculations.distance_between(
          [latitude, longitude],
          [spot.latitude, spot.longitude]
        )
        result[:distance] = distance.round(2)
        result[:label] = "#{spot.name} (#{distance.round(1)}km) - #{spot.address}"
      end

      result
    end

    render json: results
  end
end
