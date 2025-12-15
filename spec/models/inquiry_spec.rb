require 'rails_helper'

RSpec.describe Inquiry, type: :model do

  describe 'バリデーション' do
    it '名前が必須である' do
      inquiry = Inquiry.new(name: '', email: 'a@example.com', inquiry_comment: 'aaaa')
      expect(inquiry.valid?).to eq(false)
      expect(inquiry.errors[:name]).to include("を入力してください")
    end

    it 'email が必須である' do
      inquiry = Inquiry.new(name: '太郎', email: '', inquiry_comment: 'aaaa')
      expect(inquiry.valid?).to eq(false)
      expect(inquiry.errors[:email]).to include("を入力してください")
    end

    it '問い合わせ内容 が必須である' do
      inquiry = Inquiry.new(name: '太郎', email: 'a@example.com', inquiry_comment: '')
      expect(inquiry.valid?).to eq(false)
      expect(inquiry.errors[:inquiry_comment]).to include("を入力してください")
    end

    it 'email の形式がメールアドレス形式である' do
      inquiry = Inquiry.new(name: '太郎', email: 'a@', inquiry_comment: 'aaaa')
      expect(inquiry.valid?).to eq(false)
      expect(inquiry.errors[:email]).to include("正しいメールアドレスの形式で入力してください（例：example@email.com）")
    end

    it '名前が50文字以内であること' do
      inquiry = Inquiry.new(name: 'あ' * 51, email: 'a@example.com', inquiry_comment: 'aaaa')
      expect(inquiry.valid?).to eq(false)
      expect(inquiry.errors[:name]).to include("名前は50文字以内で入力してください")
    end

    it '問い合わせ内容が1000文字以内であること' do
      inquiry = Inquiry.new(name: '太郎', email: 'a@example.com', inquiry_comment: 'あ' * 1001)
      expect(inquiry.valid?).to eq(false)
      expect(inquiry.errors[:inquiry_comment]).to include("お問い合わせ内容は1000文字以内で入力してください")
    end
  end

  describe "enum の動作確認（動作テスト）" do
    it "status が設定できる" do
      inquiry = described_class.new(status: :pending)
      expect(inquiry.status).to eq("pending")
    end

    it "in_progress が設定できる" do
      inquiry = Inquiry.new(status: :in_progress)
      expect(inquiry.status).to eq("in_progress")
    end

    it "completed が設定できる" do
      inquiry = Inquiry.new(status: :completed)
      expect(inquiry.status).to eq("completed")
    end
  end

  describe "scope: recent" do
    it '新しい順に並ぶ' do
      older = Inquiry.create!(name: 'a', email: 'a@example.com', inquiry_comment: 'a', created_at: 1.day.ago)
      newer = Inquiry.create!(name: 'b', email: 'b@example.com', inquiry_comment: 'b', created_at: Time.current)

      expect(Inquiry.recent.first).to eq(newer)
    end
  end

  describe ".unread_count" do
    it "未読の件数を返す" do
      Inquiry.create!(name: 'a', email: 'a@example.com', inquiry_comment: 'a', status: :pending)
      Inquiry.create!(name: 'b', email: 'b@example.com', inquiry_comment: 'b', status: :completed)

      expect(Inquiry.unread_count).to eq(1)
    end
  end
end