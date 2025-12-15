require 'rails_helper'

RSpec.describe "SpotImageUpdateRequests", type: :request do
  let!(:spot) { create(:spot) }

  describe "GET /spots/:spot_id/spot_image_update_requests/new" do
    it "newページが表示される" do
      get new_spot_spot_image_update_request_path(spot_id: spot.id)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /spots/:spot_id/spot_image_update_requests" do
    context "正常なパラメータの場合" do
      let(:params) do
        {
          spot_image_update_request: {
            request_type: "remove",
            delete_images: []
          }
        }
      end

      it "リクエストが作成される" do
        expect {
          post spot_spot_image_update_requests_path(spot_id: spot.id), params: params
        }.to change(SpotImageUpdateRequest, :count).by(1)

        expect(response).to redirect_to(spot_path(spot))
      end
    end

    context "不正なパラメータの場合" do
      let(:params) do
        {
          spot_image_update_request: {
            request_type: nil
          }
        }
      end

      it "保存されず422になる" do
        post spot_spot_image_update_requests_path(spot_id: spot.id), params: params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end