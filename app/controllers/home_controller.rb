class HomeController < ApplicationController
  def index
    @q = Spot.ransack(params[:q])
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
      @spots = []
    end
  end

  def search
    # パラメータの検証・サニタイズ
    query = params[:q]&.strip
    latitude = params[:latitude]&.to_f  # 位置情報も受け取るように追加
    longitude = params[:longitude]&.to_f

    if query.blank?
      render json: []
      return
    end

    # データベースからデータを取得
    spots = Spot.select(:id, :name, :address, :latitude, :longitude)
                .where("name ILIKE ?", "%#{query}%")
                .limit(10)
                .order(:name)

    # 距離順での並び替えを追加
    if latitude.present? && longitude.present?
      spots = spots.near([latitude, longitude], 10).limit(10)
    else
      spots = spots.limit(10).order(:name)
    end

    # データを整形してJSONで返す
    results = spots.map do |spot|
      result = {
        label: "#{spot.name} - #{spot.address}",
        value: spot.name,
        id: spot.id
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
