require 'rails_helper'

RSpec.describe "Spots", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }

  # Devise（デバイズ）ログイン
  before do
    sign_in user
  end

  # GET /spots/new
  describe "GET /new" do
    it "new テンプレートを表示する" do
      get new_spot_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("新規スポット") # 画面の文字に合わせて調整
    end
  end

  # GET /spots/:id
  describe "GET /spots/:id" do
    it "スポットの詳細ページを表示する" do
      get spot_path(spot)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("店A")
    end
  end


  # POST /spots
  describe "POST /spots" do
    context "有効なデータのとき" do
      let(:valid_params) {
        {
          spot: {
            name: "テスト店",
            address: "東京都新宿区",
            tel: "09012345678",
            opening_hours: "10:00〜20:00",
            latitude: 35.0,
            longitude: 139.0,
            business_status: "open",
            child_chair: true,
            tatami_seat: false,
            child_tableware: true,
            bring_baby_food: true,
            stroller_ok: true,
            child_menu: false,
            parking: true,
            other_facility: "特になし"
          }
        }
      }

      it "スポットが保存される" do
        expect {
          post spots_path, params: valid_params
        }.to change(Spot, :count).by(1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(Spot.last)
      end
    end

    context "無効なデータのとき" do
      let(:invalid_params) {
        { spot: { name: "", address: "" } }
      }

      it "保存されず new を再表示する" do
        expect {
          post spots_path, params: invalid_params
        }.not_to change(Spot, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end