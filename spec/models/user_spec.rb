require 'rails_helper'

RSpec.describe User, type: :model do
  # describeブロックは、テスト対象のクラスやメソッドなどのグループを定義
  # itブロックは、特定のテストケースを定義し、1つのitブロックは1つのテストケース
  # バリデーションテスト
  describe 'バリデーション' do
    it '名前が必須である' do
      user = User.new(name: '', email: 'a@example.com', password: 'password')
      expect(user.valid?).to eq(false)
      expect(user.errors[:name]).to include("を入力してください")
    end

    it 'Deviseユーザーは email が必須' do
      user = User.new(name: 'test', email: '', password: 'password')
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("を入力してください")
    end

    it 'OAuthユーザーは email なしでもOK（unless: :oauth_user?）' do
      user = User.new(
        name: 'LINE User',
        provider: 'line',
        uid: '123456',
        email: 'dummy@example.com',
        password: Devise.friendly_token[0, 20]
      )

      expect(user.valid?).to eq(true)
    end

    it 'Deviseユーザーはemail が重複しない' do
      create(:user, email: 'test@example.com')
      user = User.new(name: 'other', email: 'test@example.com', password: 'password')

      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it 'uid + provider の組み合わせが重複しない' do
      create(:user, provider: 'line', uid: 'abc')
      user = User.new(provider: 'line', uid: 'abc')

      expect(user.valid?).to eq(false)
      expect(user.errors[:uid]).to include("はすでに存在します")
    end
  end

  describe '#oauth_user?' do
    it 'LINEユーザーなら true' do
      user = User.new(provider: 'line', uid: '123')
      expect(user.oauth_user?).to eq(true)
    end

    it 'Googleユーザーなら true' do
      user = User.new(provider: 'google_oauth2', uid: '999')
      expect(user.oauth_user?).to eq(true)
    end

    it '通常ユーザーなら false' do
      user = User.new(provider: nil, uid: nil)
      expect(user.oauth_user?).to eq(false)
    end
  end

  describe '.sign_in_or_create_user' do
    it '新規OAuthユーザーを作成できる' do
      auth = OmniAuth::AuthHash.new(
        provider: 'line',
        uid: 'abc123',
        info: { email: 'test@example.com', name: 'LINE User' }
      )

      user = User.sign_in_or_create_user(auth)

      expect(user).to be_persisted
      expect(user.provider).to eq('line')
      expect(user.uid).to eq('abc123')
    end
  end
end