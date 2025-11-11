class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # マイページ表示
  def mypage
    @user = current_user
  end

  # 編集
  def edit_mypage
    @user = current_user
  end

  # 更新
  def update_mypage

    # LINEユーザーか
    if @user.line_user?
      permitted_params = user_params_for_line_user
    else
      permitted_params = user_params_for_normal_user
    end

    if @user.update(permitted_params)
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      render :edit, alert: 'プロフィールの更新に失敗しました'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params_for_line_user
    params.require(:user).permit(:name)
  end

  # パスワード・メアドはDevise管理のため不要
  def user_params_for_normal_user
    # 通常ユーザーでも、メール・パスワードは別ページで変更
    params.require(:user).permit(:name)
  end
end
