class UsersController < ApplicationController
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
    @user = current_user
    if @user.update(user_paramus)
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      render :edit_mypage
    end
  end

  private

  # パスワード・メアドはDevise管理のため不要
  def user_paramus
    params.require(:user).permit(:name)
  end
end
