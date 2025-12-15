require 'rails_helper'

RSpec.describe SpotImageUpdateRequest, type: :model do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }

  let(:request_data_add) do
    {
      "add_images" => [
        {
          "url" => "https://example.com/sample.jpg",
          "original_filename" => "sample.jpg",
          "content_type" => "image/jpeg"
        }
      ]
    }
  end

  let(:request_data_remove) do
    {
      "delete_image_ids" => ["123"]
    }
  end

  describe "enum の動作確認（動作テスト）" do
    it "request_type が設定できる" do
      req = described_class.new(request_type: :add)
      expect(req.request_type).to eq("add")
    end

    it "status が設定できる" do
      req = described_class.new(status: :pending)
      expect(req.status).to eq("pending")
    end
  end

  describe "#approve!" do
    context "add（追加）の場合" do
      it "status が approved に変わる" do
        req = create(
          :spot_image_update_request,
          user: user,
          spot: spot,
          request_type: :add,
          request_data: request_data_add,
          status: :pending
        )

        # add_images を呼ぶかどうか確認（実際に画像はつけない）
        allow(req).to receive(:add_images)

        req.approve!

        expect(req.status).to eq("approved")
        expect(req).to have_received(:add_images)
      end
    end

    context "remove（削除）の場合" do
      it "delete_images が呼ばれる" do
        req = create(
          :spot_image_update_request,
          user: user,
          spot: spot,
          request_type: :remove,
          request_data: request_data_remove,
          status: :pending
        )

        allow(req).to receive(:delete_images)

        req.approve!

        expect(req).to have_received(:delete_images)
      end
    end

    context "both（追加＋削除）の場合" do
      it "delete_images と add_images が両方呼ばれる" do
        req = create(
          :spot_image_update_request,
          user: user,
          spot: spot,
          request_type: :both,
          request_data: request_data_add.merge(request_data_remove),
          status: :pending
        )

        allow(req).to receive(:delete_images)
        allow(req).to receive(:add_images)

        req.approve!

        expect(req).to have_received(:delete_images)
        expect(req).to have_received(:add_images)
      end
    end
  end

  describe "#reject!" do
    it "status が rejected になる" do
      req = create(
        :spot_image_update_request,
        user: user,
        spot: spot,
        request_type: :add,
        request_data: request_data_add,
        status: :pending
      )

      req.reject!

      expect(req.status).to eq("rejected")
    end
  end
end