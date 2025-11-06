class PagesController < ApplicationController
  # 利用規約画面
  def terms
  end

  # 同意画面
  def terms_agreement
  end

  # プライバシーポリシー画面
  def privacy_policy
  end

  # 利用規約への同意処理
  def create_agreement
    if params[:agreed] == '1'
      # 同意した場合：セッションに同意情報を保存
      session[:terms_agreement] = true
      session[:agreed_at] = Time.current
      session[:agreed_ip] = request.remote_ip

      redirect_to new_user_registration_path
    else
      # 同意しない場合は同意画面に戻る
      flash[:danger] = '利用規約への同意が必要です'
      redirect_to terms_agreement_path
    end
  end

end
