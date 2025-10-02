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
  end
end
