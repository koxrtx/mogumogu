require 'rails_helper'

RSpec.describe User, type: :model do
  # バリデーションテスト
  it "nameがなければ無効" do
    user = User.new(name: nil)
    expect(user).not_to be_valid
  end

  # メソッドのテスト
  describe "#some_method" do
    it "正しく動く" do
      user = FactoryBot.create(:user)
      expect(user.some_method).to eq expected_value
    end
  end
end