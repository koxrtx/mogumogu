class MapsController < ApplicationController
  # マップに投稿一覧を渡す
  def search
    @spots = Spot.all
    @spots_json = @spots.to_json(
      only: [
        :id,:id, :name, :address, :latitude, :longitude, :other_facility_comment,
        :child_chair, :tatami_seat, :child_tableware, :bring_baby_food,
        :stroller_ok, :child_menu, :parking, :other_facility
      ]
    )
    # 近い順に10件表示
    if params[:lat].present? && params[:lng].present?
      @spots_near = Spot.near([params[:lat], params[:lng]], 5, units: :km).limit(10)
    else
      @spots_near = []
    end
  end
end
