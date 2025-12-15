require 'rails_helper'

RSpec.describe "SpotUpdateRequests", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot, user: user) }

  before do
    # Warden を使ったログイン
    login_as(user, scope: :user)
  end

  describe "GET /spots/:spot_id/spot_update_requests/new" do
    it "修正依頼の新規画面が表示される" do
      get new_spot_spot_update_request_path(spot)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(spot.name)
    end
  end

  describe "POST /spots/:spot_id/spot_update_requests" do
    context "正しいパラメータのとき" do
      it "修正依頼が作成され、spot詳細へリダイレクトされる" do
        expect {
          post spot_spot_update_requests_path(spot), params: {
            spot_update_request: {
              name: "修正後の店名",
              address: "東京都",
              tel: "090-0000-0000"
            }
          }
        }.to change(SpotUpdateRequest, :count).by(1)

        expect(response).to redirect_to(spot_path(spot))
      end
    end

    context "不正なパラメータのとき" do
      it "保存されず new が再表示される" do
        post spot_spot_update_requests_path(spot), params: {
          spot_update_request: {
            name: "" # 必須エラー想定
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /spots/:spot_id/spot_update_requests/closure_report" do
    it "閉店依頼が作成される" do
      expect {
        post closure_report_spot_spot_update_requests_path(spot)
      }.to change(SpotUpdateRequest, :count).by(1)

      request = SpotUpdateRequest.last
      expect(request.request_type).to eq("closure")
      expect(request.status).to eq("pending")
    end
  end
end