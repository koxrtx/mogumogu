require 'rails_helper'

RSpec.describe "Maps", type: :request do
  describe "GET /maps/search" do
    let(:user) { create(:user) }

    let!(:spot) do
      Spot.create!(
        name: "テスト店舗",
        address: "東京都渋谷区",
        latitude: 35.6580,
        longitude: 139.7016,
        business_status: :open,
        user: user
      )
    end

    context "位置情報がない場合" do
      it "正常に表示され、@spots_near は空になる" do
        get search_map_path

        expect(response).to have_http_status(:ok)
        expect(assigns(:spots)).to include(spot)
        expect(assigns(:spots_near)).to eq([])
      end
    end

    context "位置情報がある場合" do
      it "近い順の店舗が取得される" do
        get search_map_path, params: {
          lat: 35.6580,
          lng: 139.7016
        }

        expect(response).to have_http_status(:ok)
        expect(assigns(:spots_near)).to include(spot)
      end
    end
  end
end