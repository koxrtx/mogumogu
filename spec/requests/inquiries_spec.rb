require 'rails_helper'

RSpec.describe "Inquiries", type: :request do
  describe "GET /inquiries/new" do
    it "お問い合わせ画面が表示される" do
      get new_inquiry_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /inquiries" do
    context "正常なパラメータの場合" do
      let(:valid_params) do
        {
          inquiry: {
            name: "テスト太郎",
            email: "test@example.com",
            inquiry_comment: "お問い合わせ内容です"
          }
        }
      end

      it "Inquiryが作成され、詳細画面にリダイレクトされる" do
        expect {
          post inquiries_path, params: valid_params
        }.to change(Inquiry, :count).by(1)

        expect(response).to have_http_status(:found) # 302
        expect(response).to redirect_to(Inquiry.last)
      end
    end

    context "不正なパラメータの場合" do
      let(:invalid_params) do
        {
          inquiry: {
            name: "",
            email: "",
            inquiry_comment: ""
          }
        }
      end

      it "保存されず、422が返る" do
        expect {
          post inquiries_path, params: invalid_params
        }.not_to change(Inquiry, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end