class SpotImageUpdateRequestsController < ApplicationController
  include Rails.application.routes.url_helpers # ← url_for を使えるようにする

  before_action :set_spot, only: [:new, :create]

  def new
    @request_type = params[:type]
    @request = @spot.spot_image_update_requests.build
  end

  def create
    add_images = params[:spot_image_update_request][:images]&.reject(&:blank?) || []
    delete_image_ids = params[:spot_image_update_request][:delete_images] || params[:delete_images] || []

    # Cloudinary にアップロードして URL を取得
    uploaded_images = add_images.map do |file|
      result = Cloudinary::Uploader.upload(file.path)
      {
        url: result['secure_url'],
        original_filename: file.original_filename,
        content_type: file.content_type
      }
    end

    # 削除予定の画像のURLを取得
    delete_image_urls = delete_image_ids.map do |id|
      attachment = @spot.images_attachments.find_by(id: id)
      attachment.present? ? url_for(attachment) : nil
    end.compact

    @request = @spot.spot_image_update_requests.build(
      request_type: spot_image_update_request_params[:request_type],
      request_data: {
        add_images: uploaded_images,
        delete_image_ids: delete_image_ids,
        delete_image_urls: delete_image_urls
      }
    )

    if @request.save
      redirect_to @request.spot, notice: '修正依頼を送信しました'
    else
      flash.now[:alert] = "送信に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def spot_image_update_request_params
    params.require(:spot_image_update_request).permit(:request_type, images: [], delete_images: [])
  end
end