class SpotsController < ApplicationController
  def new
    @spot = Spot.new
  end

  def show
  end

  def create
    @spot = current_user.spots.build(spot_params)

    if @spot.save
      redirect_to @spot, notice: 'お店の情報を投稿しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def spot_params
    
  end
end
