require 'rails_helper'

RSpec.describe 'Devise Debug', type: :request do
  it 'Deviseのマッピングが存在する' do
    expect(Devise.mappings).to be_present
    expect(Devise.mappings[:user]).to be_present
  end
  
  it 'Userモデルがdeviseを使っている' do
    expect(User.ancestors).to include(Devise::Models::Authenticatable)
  end
  
  it 'Userを作成できる' do
    user = create(:user)
    expect(user).to be_persisted
    expect(user.email).to be_present
  end
  
  it 'Deviseのルーティングが存在する' do
    expect { get new_user_session_path }.not_to raise_error
  end
  
  it 'sign_inが使える' do
    user = create(:user)
    
    # sign_inヘルパーを使用（Deviseのテストヘルパー）
    sign_in user
    
    # ログイン後にroot_pathにアクセス
    get root_path
    
    # 正常にアクセスできることを確認
    expect(response).to have_http_status(:success)
  end
end