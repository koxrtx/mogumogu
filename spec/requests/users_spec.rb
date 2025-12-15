require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:user) { create(:user) }
  let(:line_user) { create(:user, :line_user) }

  describe 'GET /mypage' do
    context '認証済みユーザーの場合' do
      before do
        login_as(user, scope: :user)
      end

      it 'マイページが表示される' do
        get mypage_path
        expect(response).to have_http_status(:success)
      end
    end

    context '未認証ユーザーの場合' do
      it 'ログインページにリダイレクトされる' do
        get mypage_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /mypage/edit' do
    before do
      login_as(user, scope: :user)
    end

    it '編集ページが表示される' do
      get edit_mypage_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /mypage' do
    context '通常ユーザーの場合' do
      before do
        login_as(user, scope: :user)
      end

      context 'パラメーターが適切な時' do
        let(:new_name) { '新しい名前' }

        it 'ユーザー名が更新される' do
          patch mypage_path, params: { user: { name: new_name } }
          expect(user.reload.name).to eq(new_name)
        end

        it 'マイページにリダイレクトされる' do
          patch mypage_path, params: { user: { name: new_name } }
          expect(response).to redirect_to(mypage_path)
        end

        it '成功メッセージが表示される' do
          patch mypage_path, params: { user: { name: new_name } }
          follow_redirect!
          expect(response.body).to include('プロフィールを更新しました')
        end
      end

      context 'パラメーターが不適切な時' do
        it '編集ページが再表示される' do
          patch mypage_path, params: { user: { name: '' } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'LINEユーザーの場合' do
      before do
        sign_in line_user
      end

      it 'ユーザー名が更新される' do
        new_name = '新しいLINEユーザー名'
        patch mypage_path, params: { user: { name: new_name } }
        expect(line_user.reload.name).to eq(new_name)
      end
    end
  end
end