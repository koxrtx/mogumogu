require 'rails_helper'

RSpec.describe SpotsController, type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot, user: user) }

  describe 'GET /spots/new' do
    context 'ログインしている場合' do
      before do
        login_as(user, scope: :user)
      end

      it '新規投稿ページが表示される' do
        get new_spot_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /spots/:id' do
    it 'スポット詳細が表示される' do
      get spot_path(spot)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /spots' do
    context 'ログインしている場合' do
      before do
        login_as(user, scope: :user)
      end

      context 'パラメーターが正しい時' do
        let(:valid_params) do
          {
            spot: {
              name: 'テスト店舗',
              address: '東京都',
              tel: '0312345678',
              opening_hours: '10:00-18:00',
              latitude: 35.0,
              longitude: 139.0
            }
          }
        end

        it 'スポットが作成される' do
          expect {
            post spots_path, params: valid_params
          }.to change(Spot, :count).by(1)
        end

        it '詳細ページにリダイレクトされる' do
          post spots_path, params: valid_params
          expect(response).to redirect_to(Spot.last)
        end

        it 'thanks フラグが立つ' do
          post spots_path, params: valid_params
          expect(flash[:thanks]).to be_truthy
        end
      end

      context 'パラメーターが不正な時' do
        let(:invalid_params) do
          {
            spot: {
              name: ''
            }
          }
        end

        it '新規投稿ページが再表示される' do
          post spots_path, params: invalid_params
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end
  end
end