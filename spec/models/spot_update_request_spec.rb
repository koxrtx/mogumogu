require 'rails_helper'

RSpec.describe SpotUpdateRequest, type: :model do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }

  describe "バリデーション（ユーザー投稿時）" do
    it "request_type が必須" do
      req = SpotUpdateRequest.new(user: user, spot: spot, request_type: nil)

      expect(req).not_to be_valid
      expect(req.errors[:request_type]).to include("を入力してください")
    end
  end

  describe "バリデーション（管理者編集時）" do
    it "admin_editing? の場合 status が必須" do
      req = SpotUpdateRequest.new(
        user: user,
        spot: spot,
        request_type: :spot_update,
        status: nil
      )
      allow(req).to receive(:admin_editing?).and_return(true)

      expect(req).not_to be_valid
      expect(req.errors[:status]).to include("を入力してください")
    end
  end

  describe "approve!（承認処理）" do
    it "spot_update の場合 店舗の情報が更新される" do
      req = SpotUpdateRequest.create!(
        user: user,
        spot: spot,
        request_type: :spot_update,
        request_data: {
          name: "新しい店名",
          opening_hours: "10:00-20:00"
        }
      )

      req.approve!
      spot.reload

      expect(req.status).to eq("approved")
      expect(spot.name).to eq("新しい店名")
      expect(spot.opening_hours).to eq("10:00-20:00")
    end

    it "closure の場合 店舗が closed（閉店）になる" do
      req = SpotUpdateRequest.create!(
        user: user,
        spot: spot,
        request_type: :closure
      )

      req.approve!
      spot.reload

      expect(req.status).to eq("approved")
      expect(spot.business_status).to eq("closed")
    end
  end

  describe "reject!" do
    it "ステータスが rejected になる" do
      req = SpotUpdateRequest.create!(
        user: user,
        spot: spot,
        request_type: :spot_update
      )

      req.reject!
      expect(req.status).to eq("rejected")
    end
  end
end