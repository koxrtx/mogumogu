require 'rails_helper'

RSpec.describe Agreement, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }

    it '有効なデータならバリデーションが通る' do
      agreement = Agreement.new(
        user: user,
        terms_version: '1.0',
        agreed_at: Time.current,
        ip_address: '127.0.0.1'
      )
      expect(agreement.valid?).to eq(true)
    end

    it 'terms_version が必須である' do
      agreement = Agreement.new(
        user: user,
        terms_version: '',
        agreed_at: Time.current,
        ip_address: '127.0.0.1'
      )
      expect(agreement.valid?).to eq(false)
      expect(agreement.errors[:terms_version]).to include("を入力してください")
    end

    it 'agreed_at が必須である' do
      agreement = Agreement.new(
        user: user,
        terms_version: '1.0',
        agreed_at: nil,
        ip_address: '127.0.0.1'
      )
      expect(agreement.valid?).to eq(false)
      expect(agreement.errors[:agreed_at]).to include("を入力してください")
    end

    it 'ip_address が必須である' do
      agreement = Agreement.new(
        user: user,
        terms_version: '1.0',
        agreed_at: Time.current,
        ip_address: ''
      )
      expect(agreement.valid?).to eq(false)
      expect(agreement.errors[:ip_address]).to include("を入力してください")
    end
  end

  describe '関連付け（Association）' do
    it 'user に属している（belongs_to）こと' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end
end