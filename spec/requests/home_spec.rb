require 'rails_helper'

RSpec.describe "Home", type: :request do
  let!(:user) { create(:user) }

  describe "GET /" do
    context "検索パラメータがある場合" do
      let!(:spot) do
        create(
          :spot,
          name: "テスト店",
          address: "東京都渋谷区",
          business_status: :open,
          user: user
        )
      end

      it "検索結果が表示される" do
        get root_path, params: {
          q: { name_or_address_cont: "テスト" }
        }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("テスト店")
      end
    end
  end

  describe "GET /search" do
    it "queryが空なら空配列を返す" do
      get search_path, params: {
        q: { name_or_address_cont: "" }
      }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end
end