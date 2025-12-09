require 'rails_helper'

RSpec.describe Spot, type: :model do
  let(:user) { User.create!(name: "太郎", email: "a@example.com", password: "password") }

  describe "バリデーション" do
    it "店舗名が必須" do
      spot = Spot.new(name: "テスト店", user: user)
      expect(spot).not_to be_valid
      expect(spot.errors[:address]).to include("を入力してください")
    end

    it "住所が必須" do
      spot = Spot.new(address: "東京都", user: user)
      expect(spot).not_to be_valid
      expect(spot.errors[:name]).to include("を入力してください")
    end

    it "住所が重複してはいけない" do
      Spot.create!(name: "店1", address: "東京都千代田区1-1", user: user)

      spot2 = Spot.new(name: "店2", address: "東京都千代田区1-1", user: user)
      expect(spot2).not_to be_valid
      expect(spot2.errors[:address]).to include("この住所はすでに登録されています")
    end
  end

  describe "ジオコーディング（住所→緯度経度）" do
    it "住所があれば緯度経度が入る" do
      spot = Spot.new(name: "テスト店", address: "東京都", user: user)

      # geocoder を偽物にする（テストで本当のAPI使わないため）
      fake_result = double("GeocoderResult", latitude: 35.0, longitude: 139.0)
      allow(Geocoder).to receive(:search).and_return([fake_result])

      spot.valid?

      expect(spot.latitude).to eq(35.0)
      expect(spot.longitude).to eq(139.0)
    end

    it "住所が見つからないとエラーになる" do
      spot = Spot.new(name: "テスト店", address: "???", user: user)

      allow(Geocoder).to receive(:search).and_return([])

      spot.valid?

      expect(spot.errors[:address]).to include("は地図で見つかりませんでした。入力を確認してください")
    end
  end

  describe "画像の枚数制限" do
    it "画像は3枚まで" do
      spot = Spot.new(name: "テスト店", address: "東京都", user: user)

      # ActiveStorage のテスト（仮画像をつける）
      4.times do
        spot.images.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/仮1.jpg")),
          filename: "仮1.jpg",
          content_type: "image/jpeg"
        )
      end

      expect(spot).not_to be_valid
      expect(spot.errors[:images]).to include("は3枚までしかアップロードできません")
    end
  end
end