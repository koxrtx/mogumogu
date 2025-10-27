class Admin::UsersController < ApplicationController
  # ユーザーがログインしているか
  before_action :authenticate_user!
  # 管理者か確認
  before_action :admin_required
  # 対象ユーザー
  before_action :set_user, only: [:show, :destroy, :update_role]

  # 一覧
  def index
    @users = User.all
    # 検索機能
    if params[:search].present?
      @users = @users.where("name ILIKE ? OR email ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    @users = @users.page(params[:page]).per(20)
  end

  def show
  end

  # 削除
  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'ユーザーを削除しました'
  end

  # 管理者変更
  def update_role
    @user.update(role: params[:role])
    redirect_to admin_users_path, notice: '権限を変更しました'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def admin_required
    redirect_to root_path unless current_user.admin?
  end
end
